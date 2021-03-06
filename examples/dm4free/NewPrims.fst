(*
  Copy of prims.fst, where we follow the idea on how to define
  effects with a minimal set of primitives.

*)
module NewPrims

(* Logical prelude, fun starts in around 80 lines *)

(* False is the empty inductive type *)
type l_False =

(* True is the singleton inductive type *)
type l_True =
  | T

(* another singleton type, with its only inhabitant written '()'
   we assume it is primitive, for convenient interop with other languages *)
assume new type unit : Type0

(*
   infix binary '==';
   proof irrelevant, heterogeneous equality in Type#0;
   primitive (TODO: make it an inductive?)
*)
assume type eq2 : #a:Type -> #b:Type -> a -> b -> Type0

(* bool is a two element type with elements {'true', 'false'}
   we assume it is primitive, for convenient interop with other languages *)
assume new type bool : Type0

(* bool-to-type coercion *)
type b2t (b:bool) = (b == true)

(* constructive conjunction *)
type c_and  (p:Type) (q:Type) =
  | And   : p -> q -> c_and p q

(* '/\'  : specialized to Type#0 *)
type l_and (p:Type0) (q:Type0) = c_and p q

(* constructive disjunction *)
type c_or   (p:Type) (q:Type) =
  | Left  : p -> c_or p q
  | Right : q -> c_or p q

(* '\/'  : specialized to Type#0 *)
type l_or (p:Type0) (q:Type0) = c_or p q

(* '==>' : specialized to Type#0 *)
type l_imp (p:Type0) (q:Type0) = p -> GTot q
                                         (* ^^^ NB: The Tot effect is primitive;            *)
				         (*         elaborated using PURE a few lines below *)
(* infix binary '<==>' *)
type l_iff (p:Type) (q:Type) = (p ==> q) /\ (q ==> p)

(* prefix unary '~' *)
type l_not (p:Type) = p ==> False

type l_ITE (p:Type) (q:Type) (r:Type) = (p ==> q) /\ (~p ==> r)

(* infix binary '<<'; a built-in well-founded partial order over all terms *)
assume type precedes : #a:Type -> #b:Type -> a -> b -> Type0

(* internalizing the typing relation for the SMT encoding: (has_type x t) *)
assume type has_type : #a:Type -> a -> Type -> Type0

(* A coercion down to universe 0 *)
type squash (p:Type) = x:unit{p}
  
(* forall (x:a). p x : specialized to Type#0 *)
type l_Forall (#a:Type) (p:a -> GTot Type0) = squash (x:a -> GTot (p x))

(* dependent pairs DTuple2 in concrete syntax is '(x:a & b x)' *)
type dtuple2 (a:Type)
             (b:(a -> GTot Type)) =
  | Mkdtuple2: _1:a
            -> _2:b _1
            -> dtuple2 a b

(* exists (x:a). p x : specialized to Type#0 *)
type l_Exists (#a:Type) (p:a -> GTot Type0) = squash (x:a & p x)

(* Fun starts here *)

(* PURE effect *)

(* Context type and ghost context type *)
type pure2_ctx  (a:Type) (e:Type) = (a -> GTot Type0) -> Tot e
type pure2_gctx (a:Type) (e:Type) = (a -> GTot Type0) -> GTot e

(* Applicative definitions *)
val pure2_pure : #a:Type -> #t:Type -> x:t -> Tot (pure2_ctx a t)
let pure2_pure #a #t x = fun _ -> x

val pure2_app : #a:Type -> #t1:Type -> #t2:Type ->
                l:pure2_gctx a (t1 -> GTot t2) ->
                r:pure2_gctx a t1 ->
                Tot (pure2_gctx a t2)
let pure2_app #a #t1 #t2 l r = fun p -> l p (r p)

val pure2_flip : #a:Type -> #t1:Type -> #t2:Type ->
                f:(t1 -> Tot (pure2_gctx a t2)) ->
                Tot (pure2_ctx a (t1->GTot t2))
let pure2_flip #a #t1 #t2 f = fun p -> fun e1 -> f e1 p

(* WP is a particular *ghost* context *)
type pure2_wp (a:Type) = pure2_gctx a Type0

type pure2_stronger (a:Type) (wp1:pure2_wp a) (wp2:pure2_wp a) =
  forall p1 p2. (
    (forall (x:a). p1 x ==> p2 x) ==> (wp1 p1 ==> wp2 p2)
  )

(* Monadic ops *)
val pure2_return : a:Type -> x:a -> Tot (pure2_wp a)
let pure2_return a x p = p x

inline let pure2_bind_wlp (a:Type) (b:Type)
                   (wlp1:pure2_wp a) (wlp2:(a -> GTot (pure2_wp b))) =
                   fun p -> wlp1 (fun (x:a) -> wlp2 x p)
inline let pure2_bind_wp  (a:Type) (b:Type)
                   (wp1:pure2_wp a) (wlp1:pure2_wp a)
                   (wp2: (a -> GTot (pure2_wp b))) (wlp2: (a -> GTot (pure2_wp b))) =
     pure2_bind_wlp a b wp1 wp2

(* Null wp, which we can't define in terms of the previous *)

val pure2_null_wp : a:Type -> Tot (pure2_wp a)
let pure2_null_wp a = fun p -> forall x. p x

(* Derived ops, these are defined in terms of the above and
   are just the same for every effect. *)

(* applicative lifts *)
val pure2_liftGA1 : #a:Type -> #t1:Type -> #t2:Type ->
                       f : (t1 -> GTot t2) ->
                            pure2_gctx a t1 ->
                       Tot (pure2_gctx a t2)
let pure2_liftGA1 #a #t1 #t2 f a1 =
                pure2_app (pure2_pure f) a1

val pure2_liftGA2 : #a:Type -> #t1:Type -> #t2:Type -> #t3:Type ->
                       f : (t1 -> t2 -> GTot t3) ->
                            pure2_gctx a t1 ->
                            pure2_gctx a t2 ->
                       Tot (pure2_gctx a t3)
let pure2_liftGA2 #a #t1 #t2 #t3 f a1 a2 =
                pure2_app (pure2_app (pure2_pure f) a1) a2

val pure2_if_then_else : a:Type -> c:Type0 ->
                        pure2_wp a -> pure2_wp a -> Tot (pure2_wp a)
let pure2_if_then_else a c = pure2_liftGA2 (l_ITE c)

let pure2_ite_wlp (a:Type) (wlp_cases:pure2_wp a) =
        fun p -> (forall (x:a). wlp_cases (fun (x':a) -> ~(eq2 #a #a x x')) \/ p x)

let pure2_ite_wp (a:Type) (wlp_cases:pure2_wp a) (wp_cases:pure2_wp a) =
        fun p -> pure2_ite_wlp a wlp_cases p
              /\ wp_cases (fun (x:a) -> True)

// only a special case of liftGA2, with t1=t2=t3=Type0
val pure2_wp_binop : a:Type -> pure2_wp a -> op:(Type0->Type0->GTot Type0) ->
                              pure2_wp a ->
                              Tot (pure2_wp a)
let pure2_wp_binop a l op r = pure2_liftGA2 op l r

// Not derivable, but apparently not needed
inline val pure2_wp_as_type : a:Type -> (wp:pure2_wp a) -> Tot Type0
inline let pure2_wp_as_type a wp = l_Forall wp

val pure2_close_wp : a:Type -> b:Type ->
                    f:(b->Tot (pure2_wp a)) ->
                    Tot (pure2_wp a)
let pure2_close_wp a b f = pure2_app (pure2_pure l_Forall)
                                    (pure2_flip f)

val pure2_assert_p : a:Type -> q:Type0 -> pure2_wp a -> Tot (pure2_wp a)
let pure2_assert_p a q wp = pure2_app (pure2_pure (l_and q)) wp

val pure2_assume_p : a:Type -> q:Type0 -> pure2_wp a -> Tot (pure2_wp a)
let pure2_assume_p a q wp = pure2_app (pure2_pure (l_imp q)) wp

(* null_wp is defined above *)

val pure2_trivial : a:Type -> pure2_wp a -> Tot Type0
let pure2_trivial a wp = pure2_stronger a (pure2_null_wp a) wp

total new_effect {
  PURE2 : a:Type -> wp:pure2_wp a -> wlp:pure2_wp a -> Effect
  with return       = pure2_return
     ; bind_wlp     = pure2_bind_wlp
     ; bind_wp      = pure2_bind_wp
     ; if_then_else = pure2_if_then_else
     ; ite_wlp      = pure2_ite_wlp
     ; ite_wp       = pure2_ite_wp
     ; wp_binop     = pure2_wp_binop
     ; wp_as_type   = pure2_wp_as_type
     ; close_wp     = pure2_close_wp
     ; assert_p     = pure2_assert_p
     ; assume_p     = pure2_assume_p
     ; null_wp      = pure2_null_wp
     ; trivial      = pure2_trivial
}

effect Pure2 (a:Type) (pre:Type0) (post:a -> Tot Type0) =
        PURE2 a
             (fun p -> pre /\ (forall (x:a). post x ==> p x)) // pure2_wp
             (fun p -> forall (x:a). pre /\ post x ==> p x)   // WLP

(* Let's go for state *)

(* "Manual" definitions. Should be derivable from the type of the WP *)
type st2_ctx  (heap:Type) (a:Type) (e:Type) =
        (a -> heap -> GTot Type0) -> heap -> Tot e
type st2_gctx (heap:Type) (a:Type) (e:Type) =
        (a -> heap -> GTot Type0) -> heap -> GTot e

val st2_pure : #heap:Type -> #a:Type -> #t:Type -> x:t ->
                        Tot (st2_ctx heap a t)
let st2_pure #heap #a #t x = fun _ -> fun _ -> x

val st2_app : #heap:Type -> #a:Type -> #t1:Type -> #t2:Type ->
                l:st2_gctx heap a (t1 -> GTot t2) ->
                r:st2_gctx heap a t1 ->
                Tot (st2_gctx heap a t2)
let st2_app #heap #a #t1 #t2 l r = fun p h -> l p h (r p h)

val st2_flip : #heap:Type -> #a:Type -> #t1:Type -> #t2:Type ->
                f:(t1 -> Tot (st2_gctx heap a t2)) ->
                Tot (st2_ctx heap a (t1->GTot t2))
let st2_flip #heap #a #t1 #t2 f = fun p -> fun h -> fun e1 -> f e1 p h

type st2_wp (heap:Type) (a:Type) = st2_gctx heap a Type0

type st2_stronger (heap:Type) (a:Type) (wp1:st2_wp heap a)
                                       (wp2:st2_wp heap a) =
  forall p1 p2. (
    (forall (x:a) (h:heap). p1 x h ==> p2 x h) ==>
      (forall (h:heap). (wp1 p1 h ==> wp2 p2 h))
  )

val st2_return : heap:Type -> a:Type -> x:a -> Tot (st2_wp heap a)
let st2_return _ a x p = fun h -> p x h

inline let st2_bind_wp       (heap:Type) (a:Type) (b:Type)
                            (wp1:st2_wp heap a) (wlp1:st2_wp heap a)
                            (wp2:(a -> GTot (st2_wp heap b))) (wlp2:(a -> GTot (st2_wp heap b)))
                            = fun p h0 ->
     wp1 (fun a h1 -> wp2 a p h1) h0
inline let st2_bind_wlp      (heap:Type) (a:Type) (b:Type)
                             (wlp1:st2_wp heap a) (wlp2:(a -> GTot (st2_wp heap b)))
                            = fun p h0 ->
     wlp1 (fun a h1 -> wlp2 a p h1) h0

val st2_null_wp : heap:Type -> a:Type -> Tot (st2_wp heap a)
let st2_null_wp _ a = fun p _ -> forall x h. p x h

inline let st2_ite_wlp       (heap:Type) (a:Type)
                             (wlp_cases:st2_wp heap a)
                             = fun p h0 ->
     (forall (a:a) (h:heap).
           wlp_cases (fun a1 h1 -> a=!=a1 \/ h=!=h1) h0
        \/ p a h)

inline let st2_ite_wp        (heap:Type) (a:Type)
                             (wlp_cases:st2_wp heap a) (wp_cases:st2_wp heap a) =
                             fun p h0 ->
     st2_ite_wlp heap a wlp_cases p h0
     /\ wp_cases (fun a h_ -> True) h0

(* Derived OPS. Are exactly the same as for pure except working
   on different types, and carrying the heap type all over *)
val st2_liftGA1 : #heap:Type -> #a:Type -> #t1:Type -> #t2:Type ->
                       f : (t1 -> GTot t2) ->
                            st2_gctx heap a t1 ->
                       Tot (st2_gctx heap a t2)
let st2_liftGA1 #heap #a #t1 #t2 f a1 =
                st2_app (st2_pure f) a1

val st2_liftGA2 : #heap:Type -> #a:Type -> #t1:Type -> #t2:Type -> #t3:Type ->
                       f : (t1 -> t2 -> GTot t3) ->
                            st2_gctx heap a t1 ->
                            st2_gctx heap a t2 ->
                       Tot (st2_gctx heap a t3)
let st2_liftGA2 #heap #a #t1 #t2 #t3 f a1 a2 =
                st2_app (st2_app (st2_pure f) a1) a2

val st2_if_then_else : heap:Type -> a:Type -> c:Type0 ->
                        st2_wp heap a -> st2_wp heap a ->
                        Tot (st2_wp heap a)
let st2_if_then_else heap a c = st2_liftGA2 (l_ITE c)

val st2_wp_binop : heap:Type -> a:Type -> st2_wp heap a -> op:(Type0->Type0->GTot Type0) ->
                              st2_wp heap a ->
                              Tot (st2_wp heap a)
let st2_wp_binop heap a l op r = st2_liftGA2 op l r

inline val st2_wp_as_type : heap:Type -> a:Type -> st2_wp heap a -> Tot Type0
inline let st2_wp_as_type heap a wp = l_Forall (fun (p,h) -> wp p h)

val st2_close_wp : heap:Type -> a:Type -> b:Type ->
                    f:(b->Tot (st2_wp heap a)) ->
                    Tot (st2_wp heap a)
let st2_close_wp heap a b f = st2_app (st2_pure l_Forall)
                                      (st2_flip f)

val st2_assert_p : heap:Type ->a:Type -> q:Type0 -> st2_wp heap a ->
                     Tot (st2_wp heap a)
let st2_assert_p heap a q wp = st2_app (st2_pure (l_and q)) wp

val st2_assume_p : heap:Type ->a:Type -> q:Type0 -> st2_wp heap a ->
                     Tot (st2_wp heap a)
let st2_assume_p heap a q wp = st2_app (st2_pure (l_imp q)) wp

val st2_trivial : heap:Type ->a:Type -> st2_wp heap a -> Tot Type0
let st2_trivial heap a wp = st2_stronger heap a (st2_null_wp heap a) wp

new_effect {
  STATE2_h (heap:Type) : result:Type -> wp:st2_wp heap result -> wlp:st2_wp heap result -> Effect
  with return       = st2_return heap
     ; bind_wp      = st2_bind_wp heap
     ; bind_wlp     = st2_bind_wlp heap
     ; if_then_else = st2_if_then_else heap
     ; ite_wlp      = st2_ite_wlp heap
     ; ite_wp       = st2_ite_wp heap
     ; wp_binop     = st2_wp_binop heap
     ; wp_as_type   = st2_wp_as_type heap
     ; close_wp     = st2_close_wp heap
     ; assert_p     = st2_assert_p heap
     ; assume_p     = st2_assume_p heap
     ; null_wp      = st2_null_wp heap
     ; trivial      = st2_trivial heap
}

(* Ex *)
type result (a:Type) =
  | V   : v:a -> result a
  | E   : e:exn -> result a
  | Err : msg:string -> result a

(* Context type and ghost context type *)
type ex2_ctx  (a:Type) (e:Type) = (result a -> GTot Type0) -> Tot e
type ex2_gctx (a:Type) (e:Type) = (result a -> GTot Type0) -> GTot e

(* Applicative definitions *)
val ex2_pure : #a:Type -> #t:Type -> x:t -> Tot (ex2_ctx a t)
let ex2_pure #a #t x = fun _ -> x

val ex2_app : #a:Type -> #t1:Type -> #t2:Type ->
                l:ex2_gctx a (t1 -> GTot t2) ->
                r:ex2_gctx a t1 ->
                Tot (ex2_gctx a t2)
let ex2_app #a #t1 #t2 l r = fun p -> l p (r p)

val ex2_flip : #a:Type -> #t1:Type -> #t2:Type ->
                f:(t1 -> Tot (ex2_gctx a t2)) ->
                Tot (ex2_ctx a (t1->GTot t2))
let ex2_flip #a #t1 #t2 f = fun p -> fun e1 -> f e1 p

(* WP is a particular *ghost* context *)
type ex2_wp (a:Type) = ex2_gctx a Type0

type ex2_stronger (a:Type) (wp1:ex2_wp a) (wp2:ex2_wp a) =
  forall p1 p2. (
    (forall (x:result a). p1 x ==> p2 x) ==> (wp1 p1 ==> wp2 p2)
  )

(* Monadic ops *)
val ex2_return : a:Type -> x:a -> Tot (ex2_wp a)
let ex2_return a x p = p (V x)

inline let ex2_bind_wlp (a:Type) (b:Type) (wlp1:ex2_wp a) (wlp2:(a -> GTot (ex2_wp b))) = fun p ->
   (forall (rb:result b). p rb \/ wlp1 (fun ra1 -> if is_V ra1
                                          then wlp2 (V.v ra1) (fun rb2 -> rb2=!=rb)
                                          else ra1 =!= rb))
inline let ex2_bind_wp (a:Type) (b:Type)
		       (wp1:ex2_wp a) (wlp1:ex2_wp a)
		       (wp2:(a -> GTot (ex2_wp b))) (wlp2:(a -> GTot (ex2_wp b))) = fun p ->
   ex2_bind_wlp a b wlp1 wlp2 p
   /\ wp1 (fun ra1 -> if is_V ra1
                   then wp2 (V.v ra1) (fun rb2 -> True)
                   else True)

inline let ex2_ite_wlp  (a:Type) (wlp_cases:ex2_wp a) = fun post ->
    (forall (a:result a). wlp_cases (fun a1 -> a=!=a1) \/ post a)
inline let ex2_ite_wp (a:Type) (wlp_cases:ex2_wp a) (wp_cases:ex2_wp a) = fun post ->
    ex2_ite_wlp a wlp_cases post
    /\ wp_cases (fun ra2 -> True)

(* Null wp, which we can't define in terms of the previous *)

val ex2_null_wp : a:Type -> Tot (ex2_wp a)
let ex2_null_wp a = fun p -> forall r. p r

(* Derived ops, these are defined in terms of the above and
   are just the same for every effect. *)

(* applicative lifts *)
val ex2_liftGA1 : #a:Type -> #t1:Type -> #t2:Type ->
                       f : (t1 -> GTot t2) ->
                            ex2_gctx a t1 ->
                       Tot (ex2_gctx a t2)
let ex2_liftGA1 #a #t1 #t2 f a1 =
                ex2_app (ex2_pure f) a1

val ex2_liftGA2 : #a:Type -> #t1:Type -> #t2:Type -> #t3:Type ->
                       f : (t1 -> t2 -> GTot t3) ->
                            ex2_gctx a t1 ->
                            ex2_gctx a t2 ->
                       Tot (ex2_gctx a t3)
let ex2_liftGA2 #a #t1 #t2 #t3 f a1 a2 =
                ex2_app (ex2_app (ex2_pure f) a1) a2

val ex2_if_then_else : a:Type -> c:Type0 ->
                        ex2_wp a -> ex2_wp a -> Tot (ex2_wp a)
let ex2_if_then_else a c = ex2_liftGA2 (l_ITE c)

// only a special case of liftGA2, with t1=t2=t3=Type0
val ex2_wp_binop : a:Type -> ex2_wp a -> op:(Type0->Type0->GTot Type0) ->
                              ex2_wp a ->
                              Tot (ex2_wp a)
let ex2_wp_binop a l op r = ex2_liftGA2 op l r

// Not derivable, but apparently not needed
inline val ex2_wp_as_type : a:Type -> (wp:ex2_wp a) -> Tot Type0
inline let ex2_wp_as_type a wp = l_Forall wp

val ex2_close_wp : a:Type -> b:Type ->
                    f:(b->Tot (ex2_wp a)) ->
                    Tot (ex2_wp a)
let ex2_close_wp a b f = ex2_app (ex2_pure l_Forall)
                                    (ex2_flip f)

val ex2_assert_p : a:Type -> q:Type0 -> ex2_wp a -> Tot (ex2_wp a)
let ex2_assert_p a q wp = ex2_app (ex2_pure (l_and q)) wp

val ex2_assume_p : a:Type -> q:Type0 -> ex2_wp a -> Tot (ex2_wp a)
let ex2_assume_p a q wp = ex2_app (ex2_pure (l_imp q)) wp

(* null_wp is defined above *)

val ex2_trivial : a:Type -> ex2_wp a -> Tot Type0
let ex2_trivial a wp = ex2_stronger a (ex2_null_wp a) wp

new_effect {
  EXN2 : result:Type -> wp:ex2_wp result -> wlp:ex2_wp result -> Effect
  with
    return       = ex2_return
  ; bind_wlp     = ex2_bind_wlp
  ; bind_wp      = ex2_bind_wp
  ; if_then_else = ex2_if_then_else
  ; ite_wlp      = ex2_ite_wlp
  ; ite_wp       = ex2_ite_wp
  ; wp_binop     = ex2_wp_binop
  ; wp_as_type   = ex2_wp_as_type
  ; close_wp     = ex2_close_wp
  ; assert_p     = ex2_assert_p
  ; assume_p     = ex2_assume_p
  ; null_wp      = ex2_null_wp
  ; trivial      = ex2_trivial
}

(* ALL effect *)
(* "Manual" definitions. Should be derivable from the type of the WP *)
type all2_ctx  (heap:Type) (a:Type) (e:Type) =
        (result a -> heap -> GTot Type0) -> heap -> Tot e
type all2_gctx (heap:Type) (a:Type) (e:Type) =
        (result a -> heap -> GTot Type0) -> heap -> GTot e

val all2_pure : #heap:Type -> #a:Type -> #t:Type -> x:t ->
                        Tot (all2_ctx heap a t)
let all2_pure #heap #a #t x = fun _ -> fun _ -> x

val all2_app : #heap:Type -> #a:Type -> #t1:Type -> #t2:Type ->
                l:all2_gctx heap a (t1 -> GTot t2) ->
                r:all2_gctx heap a t1 ->
                Tot (all2_gctx heap a t2)
let all2_app #heap #a #t1 #t2 l r = fun p h -> l p h (r p h)

val all2_flip : #heap:Type -> #a:Type -> #t1:Type -> #t2:Type ->
                f:(t1 -> Tot (all2_gctx heap a t2)) ->
                Tot (all2_ctx heap a (t1->GTot t2))
let all2_flip #heap #a #t1 #t2 f = fun p -> fun h -> fun e1 -> f e1 p h

type all2_wp (heap:Type) (a:Type) = all2_gctx heap a Type0

type all2_stronger (heap:Type) (a:Type) (wp1:all2_wp heap a)
                                        (wp2:all2_wp heap a) =
  forall p1 p2. (
    (forall (x:result a) (h:heap). p1 x h ==> p2 x h) ==>
    (forall (h:heap). (wp1 p1 h ==> wp2 p2 h))
  )

val all2_return : heap:Type -> a:Type -> x:a -> Tot (all2_wp heap a)
let all2_return _ a x p = fun h -> p (V x) h

inline let all2_bind_wp (heap:Type) (a:Type) (b:Type)
                        (wp1:all2_wp heap a) (wlp1:all2_wp heap a)
                        (wp2:(a -> GTot (all2_wp heap b))) (wlp2:(a -> GTot (all2_wp heap b))) = fun p h0 ->
   (wp1 (fun ra h1 -> is_V ra ==> wp2 (V.v ra) p h1) h0)

inline let all2_bind_wlp (heap:Type) (a:Type) (b:Type)
                         (wlp1:all2_wp heap a) (wlp2: (a -> GTot (all2_wp heap b))) =
   fun (p : result b -> heap -> GTot Type0) (h0 : heap) ->
   (forall rb h. wlp1 (fun ra h1 ->
       if is_V ra
       then wlp2 (V.v ra) (fun rb2 h2 -> rb=!=rb2 \/ h=!=h2) h1
       else rb=!=ra \/ h=!=h1) h0 \/ p rb h)

val all2_null_wp : heap:Type -> a:Type -> Tot (all2_wp heap a)
let all2_null_wp _ a = fun p _ -> forall x h. p x h

inline let all2_ite_wlp  (heap:Type) (a:Type)
                         (wlp_cases:all2_wp heap a) = fun post h0 ->
     (forall (ra:result a) (h:heap). wlp_cases (fun ra2 h2 -> ra=!=ra2 \/ h=!=h2) h0 \/ post ra h)
inline let all2_ite_wp (heap:Type) (a:Type)
                       (wlp_cases:all2_wp heap a) (wp_cases:all2_wp heap a) = fun post h0 ->
     (forall (ra:result a) (h:heap). wlp_cases (fun ra2 h2 -> ra=!=ra2 \/ h=!=h2) h0 \/ post ra h)
      /\ wp_cases (fun _a _b -> True) h0

(* Derived OPS. Are exactly the same as for pure except working
   on different types, and carrying the heap type all over *)
val all2_liftGA1 : #heap:Type -> #a:Type -> #t1:Type -> #t2:Type ->
                       f : (t1 -> GTot t2) ->
                            all2_gctx heap a t1 ->
                       Tot (all2_gctx heap a t2)
let all2_liftGA1 #heap #a #t1 #t2 f a1 =
                all2_app (all2_pure f) a1

val all2_liftGA2 : #heap:Type -> #a:Type -> #t1:Type -> #t2:Type -> #t3:Type ->
                       f : (t1 -> t2 -> GTot t3) ->
                            all2_gctx heap a t1 ->
                            all2_gctx heap a t2 ->
                       Tot (all2_gctx heap a t3)
let all2_liftGA2 #heap #a #t1 #t2 #t3 f a1 a2 =
                all2_app (all2_app (all2_pure f) a1) a2

val all2_if_then_else : heap:Type -> a:Type -> c:Type0 ->
                        all2_wp heap a -> all2_wp heap a ->
                        Tot (all2_wp heap a)
let all2_if_then_else heap a c = all2_liftGA2 (l_ITE c)

val all2_wp_binop : heap:Type -> a:Type -> all2_wp heap a -> op:(Type0->Type0->GTot Type0) ->
                              all2_wp heap a ->
                              Tot (all2_wp heap a)
let all2_wp_binop heap a l op r = all2_liftGA2 op l r

inline val all2_wp_as_type : heap:Type -> a:Type -> all2_wp heap a -> Tot Type0
inline let all2_wp_as_type heap a wp = l_Forall (fun (p,h) -> wp p h)

val all2_close_wp : heap:Type -> a:Type -> b:Type ->
                    f:(b->Tot (all2_wp heap a)) ->
                    Tot (all2_wp heap a)
let all2_close_wp heap a b f = all2_app (all2_pure l_Forall)
                                        (all2_flip f)

val all2_assert_p : heap:Type ->a:Type -> q:Type0 -> all2_wp heap a ->
                     Tot (all2_wp heap a)
let all2_assert_p heap a q wp = all2_app (all2_pure (l_and q)) wp

val all2_assume_p : heap:Type ->a:Type -> q:Type0 -> all2_wp heap a ->
                     Tot (all2_wp heap a)
let all2_assume_p heap a q wp = all2_app (all2_pure (l_imp q)) wp

val all2_trivial : heap:Type ->a:Type -> all2_wp heap a -> Tot Type0
let all2_trivial heap a wp = all2_stronger heap a (all2_null_wp heap a) wp

new_effect {
  ALL2_h (heap:Type) : a:Type -> wp:all2_wp heap a -> wlp:all2_wp heap a -> Effect
  with
    return       = all2_return       heap
  ; bind_wp      = all2_bind_wp      heap
  ; bind_wlp     = all2_bind_wlp     heap
  ; if_then_else = all2_if_then_else heap
  ; ite_wlp      = all2_ite_wlp      heap
  ; ite_wp       = all2_ite_wp       heap
  ; wp_binop     = all2_wp_binop     heap
  ; wp_as_type   = all2_wp_as_type   heap
  ; close_wp     = all2_close_wp     heap
  ; assert_p     = all2_assert_p     heap
  ; assume_p     = all2_assume_p     heap
  ; null_wp      = all2_null_wp      heap
  ; trivial      = all2_trivial      heap
}

