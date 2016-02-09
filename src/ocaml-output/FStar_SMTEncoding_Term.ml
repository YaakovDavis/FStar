
open Prims
type sort =
| Bool_sort
| Int_sort
| String_sort
| Ref_sort
| Term_sort
| Fuel_sort
| Array of (sort * sort)
| Arrow of (sort * sort)
| Sort of Prims.string

let is_Bool_sort : sort  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| Bool_sort -> begin
true
end
| _ -> begin
false
end))

let is_Int_sort : sort  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| Int_sort -> begin
true
end
| _ -> begin
false
end))

let is_String_sort : sort  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| String_sort -> begin
true
end
| _ -> begin
false
end))

let is_Ref_sort : sort  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| Ref_sort -> begin
true
end
| _ -> begin
false
end))

let is_Term_sort : sort  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| Term_sort -> begin
true
end
| _ -> begin
false
end))

let is_Fuel_sort : sort  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| Fuel_sort -> begin
true
end
| _ -> begin
false
end))

let is_Array : sort  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| Array (_) -> begin
true
end
| _ -> begin
false
end))

let is_Arrow : sort  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| Arrow (_) -> begin
true
end
| _ -> begin
false
end))

let is_Sort : sort  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| Sort (_) -> begin
true
end
| _ -> begin
false
end))

let ___Array____0 : sort  ->  (sort * sort) = (fun projectee -> (match (projectee) with
| Array (_96_10) -> begin
_96_10
end))

let ___Arrow____0 : sort  ->  (sort * sort) = (fun projectee -> (match (projectee) with
| Arrow (_96_13) -> begin
_96_13
end))

let ___Sort____0 : sort  ->  Prims.string = (fun projectee -> (match (projectee) with
| Sort (_96_16) -> begin
_96_16
end))

let rec strSort : sort  ->  Prims.string = (fun x -> (match (x) with
| Bool_sort -> begin
"Bool"
end
| Int_sort -> begin
"Int"
end
| Term_sort -> begin
"Term"
end
| String_sort -> begin
"String"
end
| Ref_sort -> begin
"Ref"
end
| Fuel_sort -> begin
"Fuel"
end
| Array (s1, s2) -> begin
(let _198_52 = (strSort s1)
in (let _198_51 = (strSort s2)
in (FStar_Util.format2 "(Array %s %s)" _198_52 _198_51)))
end
| Arrow (s1, s2) -> begin
(let _198_54 = (strSort s1)
in (let _198_53 = (strSort s2)
in (FStar_Util.format2 "(%s -> %s)" _198_54 _198_53)))
end
| Sort (s) -> begin
s
end))

type op =
| True
| False
| Not
| And
| Or
| Imp
| Iff
| Eq
| LT
| LTE
| GT
| GTE
| Add
| Sub
| Div
| Mul
| Minus
| Mod
| ITE
| Var of Prims.string

let is_True : op  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| True -> begin
true
end
| _ -> begin
false
end))

let is_False : op  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| False -> begin
true
end
| _ -> begin
false
end))

let is_Not : op  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| Not -> begin
true
end
| _ -> begin
false
end))

let is_And : op  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| And -> begin
true
end
| _ -> begin
false
end))

let is_Or : op  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| Or -> begin
true
end
| _ -> begin
false
end))

let is_Imp : op  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| Imp -> begin
true
end
| _ -> begin
false
end))

let is_Iff : op  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| Iff -> begin
true
end
| _ -> begin
false
end))

let is_Eq : op  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| Eq -> begin
true
end
| _ -> begin
false
end))

let is_LT : op  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| LT -> begin
true
end
| _ -> begin
false
end))

let is_LTE : op  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| LTE -> begin
true
end
| _ -> begin
false
end))

let is_GT : op  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| GT -> begin
true
end
| _ -> begin
false
end))

let is_GTE : op  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| GTE -> begin
true
end
| _ -> begin
false
end))

let is_Add : op  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| Add -> begin
true
end
| _ -> begin
false
end))

let is_Sub : op  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| Sub -> begin
true
end
| _ -> begin
false
end))

let is_Div : op  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| Div -> begin
true
end
| _ -> begin
false
end))

let is_Mul : op  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| Mul -> begin
true
end
| _ -> begin
false
end))

let is_Minus : op  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| Minus -> begin
true
end
| _ -> begin
false
end))

let is_Mod : op  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| Mod -> begin
true
end
| _ -> begin
false
end))

let is_ITE : op  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| ITE -> begin
true
end
| _ -> begin
false
end))

let is_Var : op  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| Var (_) -> begin
true
end
| _ -> begin
false
end))

let ___Var____0 : op  ->  Prims.string = (fun projectee -> (match (projectee) with
| Var (_96_36) -> begin
_96_36
end))

type qop =
| Forall
| Exists

let is_Forall : qop  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| Forall -> begin
true
end
| _ -> begin
false
end))

let is_Exists : qop  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| Exists -> begin
true
end
| _ -> begin
false
end))

type term' =
| Integer of Prims.string
| BoundV of Prims.int
| FreeV of fv
| App of (op * term Prims.list)
| Quant of (qop * pat Prims.list Prims.list * Prims.int Prims.option * sort Prims.list * term)
| Labeled of (term * Prims.string * FStar_Range.range) 
 and term =
{tm : term'; hash : Prims.string; freevars : fvs FStar_Syntax_Syntax.memo} 
 and pat =
term 
 and fv =
(Prims.string * sort) 
 and fvs =
fv Prims.list

let is_Integer : term'  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| Integer (_) -> begin
true
end
| _ -> begin
false
end))

let is_BoundV : term'  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| BoundV (_) -> begin
true
end
| _ -> begin
false
end))

let is_FreeV : term'  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| FreeV (_) -> begin
true
end
| _ -> begin
false
end))

let is_App : term'  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| App (_) -> begin
true
end
| _ -> begin
false
end))

let is_Quant : term'  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| Quant (_) -> begin
true
end
| _ -> begin
false
end))

let is_Labeled : term'  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| Labeled (_) -> begin
true
end
| _ -> begin
false
end))

let is_Mkterm : term  ->  Prims.bool = (Obj.magic ((fun _ -> (FStar_All.failwith "Not yet implemented:is_Mkterm"))))

let ___Integer____0 : term'  ->  Prims.string = (fun projectee -> (match (projectee) with
| Integer (_96_42) -> begin
_96_42
end))

let ___BoundV____0 : term'  ->  Prims.int = (fun projectee -> (match (projectee) with
| BoundV (_96_45) -> begin
_96_45
end))

let ___FreeV____0 : term'  ->  fv = (fun projectee -> (match (projectee) with
| FreeV (_96_48) -> begin
_96_48
end))

let ___App____0 : term'  ->  (op * term Prims.list) = (fun projectee -> (match (projectee) with
| App (_96_51) -> begin
_96_51
end))

let ___Quant____0 : term'  ->  (qop * pat Prims.list Prims.list * Prims.int Prims.option * sort Prims.list * term) = (fun projectee -> (match (projectee) with
| Quant (_96_54) -> begin
_96_54
end))

let ___Labeled____0 : term'  ->  (term * Prims.string * FStar_Range.range) = (fun projectee -> (match (projectee) with
| Labeled (_96_57) -> begin
_96_57
end))

let fv_eq : fv  ->  fv  ->  Prims.bool = (fun x y -> ((Prims.fst x) = (Prims.fst y)))

let fv_sort = (fun x -> (Prims.snd x))

let freevar_eq : term  ->  term  ->  Prims.bool = (fun x y -> (match ((x.tm, y.tm)) with
| (FreeV (x), FreeV (y)) -> begin
(fv_eq x y)
end
| _96_70 -> begin
false
end))

let freevar_sort : term  ->  sort = (fun _96_1 -> (match (_96_1) with
| {tm = FreeV (x); hash = _96_75; freevars = _96_73} -> begin
(fv_sort x)
end
| _96_80 -> begin
(FStar_All.failwith "impossible")
end))

let fv_of_term : term  ->  fv = (fun _96_2 -> (match (_96_2) with
| {tm = FreeV (fv); hash = _96_85; freevars = _96_83} -> begin
fv
end
| _96_90 -> begin
(FStar_All.failwith "impossible")
end))

let rec freevars : term  ->  fv Prims.list = (fun t -> (match (t.tm) with
| (Integer (_)) | (BoundV (_)) -> begin
[]
end
| FreeV (fv) -> begin
(fv)::[]
end
| App (_96_101, tms) -> begin
(FStar_List.collect freevars tms)
end
| (Quant (_, _, _, _, t)) | (Labeled (t, _, _)) -> begin
(freevars t)
end))

let free_variables : term  ->  fvs = (fun t -> (match ((FStar_ST.read t.freevars)) with
| Some (b) -> begin
b
end
| None -> begin
(let fvs = (let _198_201 = (freevars t)
in (FStar_Util.remove_dups fv_eq _198_201))
in (let _96_127 = (FStar_ST.op_Colon_Equals t.freevars (Some (fvs)))
in fvs))
end))

let qop_to_string : qop  ->  Prims.string = (fun _96_3 -> (match (_96_3) with
| Forall -> begin
"forall"
end
| Exists -> begin
"exists"
end))

let op_to_string : op  ->  Prims.string = (fun _96_4 -> (match (_96_4) with
| True -> begin
"true"
end
| False -> begin
"false"
end
| Not -> begin
"not"
end
| And -> begin
"and"
end
| Or -> begin
"or"
end
| Imp -> begin
"implies"
end
| Iff -> begin
"iff"
end
| Eq -> begin
"="
end
| LT -> begin
"<"
end
| LTE -> begin
"<="
end
| GT -> begin
">"
end
| GTE -> begin
">="
end
| Add -> begin
"+"
end
| Sub -> begin
"-"
end
| Div -> begin
"div"
end
| Mul -> begin
"*"
end
| Minus -> begin
"-"
end
| Mod -> begin
"mod"
end
| ITE -> begin
"ite"
end
| Var (s) -> begin
s
end))

let weightToSmt : Prims.int Prims.option  ->  Prims.string = (fun _96_5 -> (match (_96_5) with
| None -> begin
""
end
| Some (i) -> begin
(let _198_208 = (FStar_Util.string_of_int i)
in (FStar_Util.format1 ":weight %s\n" _198_208))
end))

let hash_of_term' : term'  ->  Prims.string = (fun t -> (match (t) with
| Integer (i) -> begin
i
end
| BoundV (i) -> begin
(let _198_211 = (FStar_Util.string_of_int i)
in (Prims.strcat "@" _198_211))
end
| FreeV (x) -> begin
(let _198_212 = (strSort (Prims.snd x))
in (Prims.strcat (Prims.strcat (Prims.fst x) ":") _198_212))
end
| App (op, tms) -> begin
(let _198_216 = (let _198_215 = (let _198_214 = (FStar_List.map (fun t -> t.hash) tms)
in (FStar_All.pipe_right _198_214 (FStar_String.concat " ")))
in (Prims.strcat (Prims.strcat "(" (op_to_string op)) _198_215))
in (Prims.strcat _198_216 ")"))
end
| Labeled (t, r1, r2) -> begin
(let _198_217 = (FStar_Range.string_of_range r2)
in (Prims.strcat (Prims.strcat t.hash r1) _198_217))
end
| Quant (qop, pats, wopt, sorts, body) -> begin
(let _198_225 = (let _198_218 = (FStar_List.map strSort sorts)
in (FStar_All.pipe_right _198_218 (FStar_String.concat " ")))
in (let _198_224 = (weightToSmt wopt)
in (let _198_223 = (let _198_222 = (FStar_All.pipe_right pats (FStar_List.map (fun pats -> (let _198_221 = (FStar_List.map (fun p -> p.hash) pats)
in (FStar_All.pipe_right _198_221 (FStar_String.concat " "))))))
in (FStar_All.pipe_right _198_222 (FStar_String.concat "; ")))
in (FStar_Util.format5 "(%s (%s)(! %s %s %s))" (qop_to_string qop) _198_225 body.hash _198_224 _198_223))))
end))

let __all_terms : term FStar_Util.smap FStar_ST.ref = (let _198_226 = (FStar_Util.smap_create 10000)
in (FStar_ST.alloc _198_226))

let all_terms : Prims.unit  ->  term FStar_Util.smap = (fun _96_184 -> (match (()) with
| () -> begin
(FStar_ST.read __all_terms)
end))

let mk : term'  ->  term = (fun t -> (let key = (hash_of_term' t)
in (match ((let _198_231 = (all_terms ())
in (FStar_Util.smap_try_find _198_231 key))) with
| Some (tm) -> begin
tm
end
| None -> begin
(let tm = (let _198_232 = (FStar_Util.mk_ref None)
in {tm = t; hash = key; freevars = _198_232})
in (let _96_191 = (let _198_233 = (all_terms ())
in (FStar_Util.smap_add _198_233 key tm))
in tm))
end)))

let mkTrue : term = (mk (App ((True, []))))

let mkFalse : term = (mk (App ((False, []))))

let mkInteger : Prims.string  ->  term = (fun i -> (mk (Integer (i))))

let mkInteger32 : Prims.int32  ->  term = (fun i -> (mkInteger (FStar_Util.string_of_int32 i)))

let mkInteger' : Prims.int  ->  term = (fun i -> (let _198_240 = (FStar_Util.string_of_int i)
in (mkInteger _198_240)))

let mkBoundV : Prims.int  ->  term = (fun i -> (mk (BoundV (i))))

let mkFreeV : (Prims.string * sort)  ->  term = (fun x -> (mk (FreeV (x))))

let mkApp' : (op * term Prims.list)  ->  term = (fun f -> (mk (App (f))))

let mkApp : (Prims.string * term Prims.list)  ->  term = (fun _96_201 -> (match (_96_201) with
| (s, args) -> begin
(mk (App ((Var (s), args))))
end))

let mkNot : term  ->  term = (fun t -> (match (t.tm) with
| App (True, _96_205) -> begin
mkFalse
end
| App (False, _96_210) -> begin
mkTrue
end
| _96_214 -> begin
(mkApp' (Not, (t)::[]))
end))

let mkAnd : (term * term)  ->  term = (fun _96_217 -> (match (_96_217) with
| (t1, t2) -> begin
(match ((t1.tm, t2.tm)) with
| (App (True, _96_220), _96_224) -> begin
t2
end
| (_96_227, App (True, _96_230)) -> begin
t1
end
| ((App (False, _), _)) | ((_, App (False, _))) -> begin
mkFalse
end
| (App (And, ts1), App (And, ts2)) -> begin
(mkApp' (And, (FStar_List.append ts1 ts2)))
end
| (_96_260, App (And, ts2)) -> begin
(mkApp' (And, (t1)::ts2))
end
| (App (And, ts1), _96_271) -> begin
(mkApp' (And, (FStar_List.append ts1 ((t2)::[]))))
end
| _96_274 -> begin
(mkApp' (And, (t1)::(t2)::[]))
end)
end))

let mkOr : (term * term)  ->  term = (fun _96_277 -> (match (_96_277) with
| (t1, t2) -> begin
(match ((t1.tm, t2.tm)) with
| ((App (True, _), _)) | ((_, App (True, _))) -> begin
mkTrue
end
| (App (False, _96_296), _96_300) -> begin
t2
end
| (_96_303, App (False, _96_306)) -> begin
t1
end
| (App (Or, ts1), App (Or, ts2)) -> begin
(mkApp' (Or, (FStar_List.append ts1 ts2)))
end
| (_96_320, App (Or, ts2)) -> begin
(mkApp' (Or, (t1)::ts2))
end
| (App (Or, ts1), _96_331) -> begin
(mkApp' (Or, (FStar_List.append ts1 ((t2)::[]))))
end
| _96_334 -> begin
(mkApp' (Or, (t1)::(t2)::[]))
end)
end))

let mkImp : (term * term)  ->  term = (fun _96_337 -> (match (_96_337) with
| (t1, t2) -> begin
(match ((t1.tm, t2.tm)) with
| (_96_339, App (True, _96_342)) -> begin
mkTrue
end
| (App (True, _96_348), _96_352) -> begin
t2
end
| (_96_355, App (Imp, t1'::t2'::[])) -> begin
(let _198_259 = (let _198_258 = (let _198_257 = (mkAnd (t1, t1'))
in (_198_257)::(t2')::[])
in (Imp, _198_258))
in (mkApp' _198_259))
end
| _96_364 -> begin
(mkApp' (Imp, (t1)::(t2)::[]))
end)
end))

let mk_bin_op : op  ->  (term * term)  ->  term = (fun op _96_368 -> (match (_96_368) with
| (t1, t2) -> begin
(mkApp' (op, (t1)::(t2)::[]))
end))

let mkMinus : term  ->  term = (fun t -> (mkApp' (Minus, (t)::[])))

let mkIff : (term * term)  ->  term = (mk_bin_op Iff)

let mkEq : (term * term)  ->  term = (mk_bin_op Eq)

let mkLT : (term * term)  ->  term = (mk_bin_op LT)

let mkLTE : (term * term)  ->  term = (mk_bin_op LTE)

let mkGT : (term * term)  ->  term = (mk_bin_op GT)

let mkGTE : (term * term)  ->  term = (mk_bin_op GTE)

let mkAdd : (term * term)  ->  term = (mk_bin_op Add)

let mkSub : (term * term)  ->  term = (mk_bin_op Sub)

let mkDiv : (term * term)  ->  term = (mk_bin_op Div)

let mkMul : (term * term)  ->  term = (mk_bin_op Mul)

let mkMod : (term * term)  ->  term = (mk_bin_op Mod)

let mkITE : (term * term * term)  ->  term = (fun _96_373 -> (match (_96_373) with
| (t1, t2, t3) -> begin
(match ((t2.tm, t3.tm)) with
| (App (True, _96_376), App (True, _96_381)) -> begin
mkTrue
end
| (App (True, _96_387), _96_391) -> begin
(let _198_280 = (let _198_279 = (mkNot t1)
in (_198_279, t3))
in (mkImp _198_280))
end
| (_96_394, App (True, _96_397)) -> begin
(mkImp (t1, t2))
end
| (_96_402, _96_404) -> begin
(mkApp' (ITE, (t1)::(t2)::(t3)::[]))
end)
end))

let mkCases : term Prims.list  ->  term = (fun t -> (match (t) with
| [] -> begin
(FStar_All.failwith "Impos")
end
| hd::tl -> begin
(FStar_List.fold_left (fun out t -> (mkAnd (out, t))) hd tl)
end))

let mkQuant : (qop * pat Prims.list Prims.list * Prims.int Prims.option * sort Prims.list * term)  ->  term = (fun _96_418 -> (match (_96_418) with
| (qop, pats, wopt, vars, body) -> begin
if ((FStar_List.length vars) = 0) then begin
body
end else begin
(match (body.tm) with
| App (True, _96_421) -> begin
body
end
| _96_425 -> begin
(mk (Quant ((qop, pats, wopt, vars, body))))
end)
end
end))

let abstr : fv Prims.list  ->  term  ->  term = (fun fvs t -> (let nvars = (FStar_List.length fvs)
in (let index_of = (fun fv -> (match ((FStar_Util.try_find_index (fv_eq fv) fvs)) with
| None -> begin
None
end
| Some (i) -> begin
Some ((nvars - (i + 1)))
end))
in (let rec aux = (fun ix t -> (match ((FStar_ST.read t.freevars)) with
| Some ([]) -> begin
t
end
| _96_440 -> begin
(match (t.tm) with
| (Integer (_)) | (BoundV (_)) -> begin
t
end
| FreeV (x) -> begin
(match ((index_of x)) with
| None -> begin
t
end
| Some (i) -> begin
(mkBoundV (i + ix))
end)
end
| App (op, tms) -> begin
(let _198_298 = (let _198_297 = (FStar_List.map (aux ix) tms)
in (op, _198_297))
in (mkApp' _198_298))
end
| Labeled (t, r1, r2) -> begin
(let _198_301 = (let _198_300 = (let _198_299 = (aux ix t)
in (_198_299, r1, r2))
in Labeled (_198_300))
in (mk _198_301))
end
| Quant (qop, pats, wopt, vars, body) -> begin
(let n = (FStar_List.length vars)
in (let _198_304 = (let _198_303 = (FStar_All.pipe_right pats (FStar_List.map (FStar_List.map (aux (ix + n)))))
in (let _198_302 = (aux (ix + n) body)
in (qop, _198_303, wopt, vars, _198_302)))
in (mkQuant _198_304)))
end)
end))
in (aux 0 t)))))

let inst : term Prims.list  ->  term  ->  term = (fun tms t -> (let n = (FStar_List.length tms)
in (let rec aux = (fun shift t -> (match (t.tm) with
| (Integer (_)) | (FreeV (_)) -> begin
t
end
| BoundV (i) -> begin
if ((0 <= (i - shift)) && ((i - shift) < n)) then begin
(FStar_List.nth tms (i - shift))
end else begin
t
end
end
| App (op, tms) -> begin
(let _198_314 = (let _198_313 = (FStar_List.map (aux shift) tms)
in (op, _198_313))
in (mkApp' _198_314))
end
| Labeled (t, r1, r2) -> begin
(let _198_317 = (let _198_316 = (let _198_315 = (aux shift t)
in (_198_315, r1, r2))
in Labeled (_198_316))
in (mk _198_317))
end
| Quant (qop, pats, wopt, vars, body) -> begin
(let m = (FStar_List.length vars)
in (let shift = (shift + m)
in (let _198_320 = (let _198_319 = (FStar_All.pipe_right pats (FStar_List.map (FStar_List.map (aux shift))))
in (let _198_318 = (aux shift body)
in (qop, _198_319, wopt, vars, _198_318)))
in (mkQuant _198_320))))
end))
in (aux 0 t))))

let mkQuant' : (qop * term Prims.list Prims.list * Prims.int Prims.option * fv Prims.list * term)  ->  term = (fun _96_506 -> (match (_96_506) with
| (qop, pats, wopt, vars, body) -> begin
(let _198_326 = (let _198_325 = (FStar_All.pipe_right pats (FStar_List.map (FStar_List.map (abstr vars))))
in (let _198_324 = (FStar_List.map fv_sort vars)
in (let _198_323 = (abstr vars body)
in (qop, _198_325, wopt, _198_324, _198_323))))
in (mkQuant _198_326))
end))

let mkForall'' : (pat Prims.list Prims.list * Prims.int Prims.option * sort Prims.list * term)  ->  term = (fun _96_511 -> (match (_96_511) with
| (pats, wopt, sorts, body) -> begin
(mkQuant (Forall, pats, wopt, sorts, body))
end))

let mkForall' : (pat Prims.list Prims.list * Prims.int Prims.option * fvs * term)  ->  term = (fun _96_516 -> (match (_96_516) with
| (pats, wopt, vars, body) -> begin
(mkQuant' (Forall, pats, wopt, vars, body))
end))

let mkForall : (pat Prims.list Prims.list * fvs * term)  ->  term = (fun _96_520 -> (match (_96_520) with
| (pats, vars, body) -> begin
(mkQuant' (Forall, pats, None, vars, body))
end))

let mkExists : (pat Prims.list Prims.list * fvs * term)  ->  term = (fun _96_524 -> (match (_96_524) with
| (pats, vars, body) -> begin
(mkQuant' (Exists, pats, None, vars, body))
end))

type caption =
Prims.string Prims.option

type binders =
(Prims.string * sort) Prims.list

type projector =
(Prims.string * sort)

type constructor_t =
(Prims.string * projector Prims.list * sort * Prims.int)

type constructors =
constructor_t Prims.list

type decl =
| DefPrelude
| DeclFun of (Prims.string * sort Prims.list * sort * caption)
| DefineFun of (Prims.string * sort Prims.list * sort * term * caption)
| Assume of (term * caption)
| Caption of Prims.string
| Eval of term
| Echo of Prims.string
| Push
| Pop
| CheckSat

let is_DefPrelude : decl  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| DefPrelude -> begin
true
end
| _ -> begin
false
end))

let is_DeclFun : decl  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| DeclFun (_) -> begin
true
end
| _ -> begin
false
end))

let is_DefineFun : decl  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| DefineFun (_) -> begin
true
end
| _ -> begin
false
end))

let is_Assume : decl  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| Assume (_) -> begin
true
end
| _ -> begin
false
end))

let is_Caption : decl  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| Caption (_) -> begin
true
end
| _ -> begin
false
end))

let is_Eval : decl  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| Eval (_) -> begin
true
end
| _ -> begin
false
end))

let is_Echo : decl  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| Echo (_) -> begin
true
end
| _ -> begin
false
end))

let is_Push : decl  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| Push -> begin
true
end
| _ -> begin
false
end))

let is_Pop : decl  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| Pop -> begin
true
end
| _ -> begin
false
end))

let is_CheckSat : decl  ->  Prims.bool = (fun _discr_ -> (match (_discr_) with
| CheckSat -> begin
true
end
| _ -> begin
false
end))

let ___DeclFun____0 : decl  ->  (Prims.string * sort Prims.list * sort * caption) = (fun projectee -> (match (projectee) with
| DeclFun (_96_527) -> begin
_96_527
end))

let ___DefineFun____0 : decl  ->  (Prims.string * sort Prims.list * sort * term * caption) = (fun projectee -> (match (projectee) with
| DefineFun (_96_530) -> begin
_96_530
end))

let ___Assume____0 : decl  ->  (term * caption) = (fun projectee -> (match (projectee) with
| Assume (_96_533) -> begin
_96_533
end))

let ___Caption____0 : decl  ->  Prims.string = (fun projectee -> (match (projectee) with
| Caption (_96_536) -> begin
_96_536
end))

let ___Eval____0 : decl  ->  term = (fun projectee -> (match (projectee) with
| Eval (_96_539) -> begin
_96_539
end))

let ___Echo____0 : decl  ->  Prims.string = (fun projectee -> (match (projectee) with
| Echo (_96_542) -> begin
_96_542
end))

type decls_t =
decl Prims.list

let mkDefineFun : (Prims.string * (Prims.string * sort) Prims.list * sort * term * caption)  ->  decl = (fun _96_548 -> (match (_96_548) with
| (nm, vars, s, tm, c) -> begin
(let _198_427 = (let _198_426 = (FStar_List.map fv_sort vars)
in (let _198_425 = (abstr vars tm)
in (nm, _198_426, s, _198_425, c)))
in DefineFun (_198_427))
end))

let constr_id_of_sort : sort  ->  Prims.string = (fun sort -> (let _198_430 = (strSort sort)
in (FStar_Util.format1 "%s_constr_id" _198_430)))

let fresh_token : (Prims.string * sort)  ->  Prims.int  ->  decl = (fun _96_552 id -> (match (_96_552) with
| (tok_name, sort) -> begin
(let _198_443 = (let _198_442 = (let _198_441 = (let _198_440 = (mkInteger' id)
in (let _198_439 = (let _198_438 = (let _198_437 = (constr_id_of_sort sort)
in (let _198_436 = (let _198_435 = (mkApp (tok_name, []))
in (_198_435)::[])
in (_198_437, _198_436)))
in (mkApp _198_438))
in (_198_440, _198_439)))
in (mkEq _198_441))
in (_198_442, Some ("fresh token")))
in Assume (_198_443))
end))

let constructor_to_decl : constructor_t  ->  decls_t = (fun _96_558 -> (match (_96_558) with
| (name, projectors, sort, id) -> begin
(let id = (FStar_Util.string_of_int id)
in (let cdecl = (let _198_447 = (let _198_446 = (FStar_All.pipe_right projectors (FStar_List.map Prims.snd))
in (name, _198_446, sort, Some ("Constructor")))
in DeclFun (_198_447))
in (let n_bvars = (FStar_List.length projectors)
in (let bvar_name = (fun i -> (let _198_450 = (FStar_Util.string_of_int i)
in (Prims.strcat "x_" _198_450)))
in (let bvar_index = (fun i -> (n_bvars - (i + 1)))
in (let bvar = (fun i s -> (let _198_458 = (let _198_457 = (bvar_name i)
in (_198_457, s))
in (mkFreeV _198_458)))
in (let bvars = (FStar_All.pipe_right projectors (FStar_List.mapi (fun i _96_573 -> (match (_96_573) with
| (_96_571, s) -> begin
(bvar i s)
end))))
in (let bvar_names = (FStar_List.map fv_of_term bvars)
in (let capp = (mkApp (name, bvars))
in (let cid_app = (let _198_462 = (let _198_461 = (constr_id_of_sort sort)
in (_198_461, (capp)::[]))
in (mkApp _198_462))
in (let cid = (let _198_468 = (let _198_467 = (let _198_466 = (let _198_465 = (let _198_464 = (let _198_463 = (mkInteger id)
in (_198_463, cid_app))
in (mkEq _198_464))
in (((capp)::[])::[], bvar_names, _198_465))
in (mkForall _198_466))
in (_198_467, Some ("Constructor distinct")))
in Assume (_198_468))
in (let disc_name = (Prims.strcat "is-" name)
in (let xfv = ("x", sort)
in (let xx = (mkFreeV xfv)
in (let disc_eq = (let _198_473 = (let _198_472 = (let _198_470 = (let _198_469 = (constr_id_of_sort sort)
in (_198_469, (xx)::[]))
in (mkApp _198_470))
in (let _198_471 = (mkInteger id)
in (_198_472, _198_471)))
in (mkEq _198_473))
in (let proj_terms = (FStar_All.pipe_right projectors (FStar_List.map (fun _96_585 -> (match (_96_585) with
| (proj, s) -> begin
(mkApp (proj, (xx)::[]))
end))))
in (let disc_inv_body = (let _198_476 = (let _198_475 = (mkApp (name, proj_terms))
in (xx, _198_475))
in (mkEq _198_476))
in (let disc_ax = (mkAnd (disc_eq, disc_inv_body))
in (let disc = (mkDefineFun (disc_name, (xfv)::[], Bool_sort, disc_ax, Some ("Discriminator definition")))
in (let projs = (let _198_487 = (FStar_All.pipe_right projectors (FStar_List.mapi (fun i _96_593 -> (match (_96_593) with
| (name, s) -> begin
(let cproj_app = (mkApp (name, (capp)::[]))
in (let _198_486 = (let _198_485 = (let _198_484 = (let _198_483 = (let _198_482 = (let _198_481 = (let _198_480 = (let _198_479 = (bvar i s)
in (cproj_app, _198_479))
in (mkEq _198_480))
in (((capp)::[])::[], bvar_names, _198_481))
in (mkForall _198_482))
in (_198_483, Some ("Projection inverse")))
in Assume (_198_484))
in (_198_485)::[])
in (DeclFun ((name, (sort)::[], s, Some ("Projector"))))::_198_486))
end))))
in (FStar_All.pipe_right _198_487 FStar_List.flatten))
in (let _198_494 = (let _198_490 = (let _198_489 = (let _198_488 = (FStar_Util.format1 "<start constructor %s>" name)
in Caption (_198_488))
in (_198_489)::(cdecl)::(cid)::projs)
in (FStar_List.append _198_490 ((disc)::[])))
in (let _198_493 = (let _198_492 = (let _198_491 = (FStar_Util.format1 "</end constructor %s>" name)
in Caption (_198_491))
in (_198_492)::[])
in (FStar_List.append _198_494 _198_493)))))))))))))))))))))))
end))

let name_binders_inner : (Prims.string * sort) Prims.list  ->  Prims.int  ->  sort Prims.list  ->  ((Prims.string * sort) Prims.list * Prims.string Prims.list * Prims.int) = (fun outer_names start sorts -> (let _96_614 = (FStar_All.pipe_right sorts (FStar_List.fold_left (fun _96_602 s -> (match (_96_602) with
| (names, binders, n) -> begin
(let prefix = (match (s) with
| Term_sort -> begin
"@x"
end
| _96_606 -> begin
"@u"
end)
in (let nm = (let _198_503 = (FStar_Util.string_of_int n)
in (Prims.strcat prefix _198_503))
in (let names = ((nm, s))::names
in (let b = (let _198_504 = (strSort s)
in (FStar_Util.format2 "(%s %s)" nm _198_504))
in (names, (b)::binders, (n + 1))))))
end)) (outer_names, [], start)))
in (match (_96_614) with
| (names, binders, n) -> begin
(names, (FStar_List.rev binders), n)
end)))

let name_binders : sort Prims.list  ->  ((Prims.string * sort) Prims.list * Prims.string Prims.list) = (fun sorts -> (let _96_619 = (name_binders_inner [] 0 sorts)
in (match (_96_619) with
| (names, binders, n) -> begin
((FStar_List.rev names), binders)
end)))

let termToSmt : term  ->  Prims.string = (fun t -> (let rec aux = (fun n names t -> (match (t.tm) with
| Integer (i) -> begin
i
end
| BoundV (i) -> begin
(let _198_515 = (FStar_List.nth names i)
in (FStar_All.pipe_right _198_515 Prims.fst))
end
| FreeV (x) -> begin
(Prims.fst x)
end
| App (op, []) -> begin
(op_to_string op)
end
| App (op, tms) -> begin
(let _198_517 = (let _198_516 = (FStar_List.map (aux n names) tms)
in (FStar_All.pipe_right _198_516 (FStar_String.concat "\n")))
in (FStar_Util.format2 "(%s %s)" (op_to_string op) _198_517))
end
| Labeled (t, _96_641, _96_643) -> begin
(aux n names t)
end
| Quant (qop, pats, wopt, sorts, body) -> begin
(let _96_656 = (name_binders_inner names n sorts)
in (match (_96_656) with
| (names, binders, n) -> begin
(let binders = (FStar_All.pipe_right binders (FStar_String.concat " "))
in (let pats_str = (match (pats) with
| ([]::[]) | ([]) -> begin
""
end
| _96_662 -> begin
(let _198_523 = (FStar_All.pipe_right pats (FStar_List.map (fun pats -> (let _198_522 = (let _198_521 = (FStar_List.map (fun p -> (let _198_520 = (aux n names p)
in (FStar_Util.format1 "%s" _198_520))) pats)
in (FStar_String.concat " " _198_521))
in (FStar_Util.format1 "\n:pattern (%s)" _198_522)))))
in (FStar_All.pipe_right _198_523 (FStar_String.concat "\n")))
end)
in (match ((pats, wopt)) with
| (([]::[], None)) | (([], None)) -> begin
(let _198_524 = (aux n names body)
in (FStar_Util.format3 "(%s (%s)\n %s);;no pats\n" (qop_to_string qop) binders _198_524))
end
| _96_674 -> begin
(let _198_526 = (aux n names body)
in (let _198_525 = (weightToSmt wopt)
in (FStar_Util.format5 "(%s (%s)\n (! %s\n %s %s))" (qop_to_string qop) binders _198_526 _198_525 pats_str)))
end)))
end))
end))
in (aux 0 [] t)))

let caption_to_string : Prims.string Prims.option  ->  Prims.string = (fun _96_6 -> (match (_96_6) with
| None -> begin
""
end
| Some (c) -> begin
(let _96_688 = (match ((FStar_Util.splitlines c)) with
| [] -> begin
(FStar_All.failwith "Impossible")
end
| hd::[] -> begin
(hd, "")
end
| hd::_96_683 -> begin
(hd, "...")
end)
in (match (_96_688) with
| (hd, suffix) -> begin
(FStar_Util.format2 ";;;;;;;;;;;;;;;;%s%s\n" hd suffix)
end))
end))

let rec declToSmt : Prims.string  ->  decl  ->  Prims.string = (fun z3options decl -> (match (decl) with
| DefPrelude -> begin
(mkPrelude z3options)
end
| Caption (c) -> begin
(let _198_535 = (FStar_All.pipe_right (FStar_Util.splitlines c) (fun _96_7 -> (match (_96_7) with
| [] -> begin
""
end
| h::t -> begin
h
end)))
in (FStar_Util.format1 "\n; %s" _198_535))
end
| DeclFun (f, argsorts, retsort, c) -> begin
(let l = (FStar_List.map strSort argsorts)
in (let _198_537 = (caption_to_string c)
in (let _198_536 = (strSort retsort)
in (FStar_Util.format4 "%s(declare-fun %s (%s) %s)" _198_537 f (FStar_String.concat " " l) _198_536))))
end
| DefineFun (f, arg_sorts, retsort, body, c) -> begin
(let _96_715 = (name_binders arg_sorts)
in (match (_96_715) with
| (names, binders) -> begin
(let body = (let _198_538 = (FStar_List.map mkFreeV names)
in (inst _198_538 body))
in (let _198_541 = (caption_to_string c)
in (let _198_540 = (strSort retsort)
in (let _198_539 = (termToSmt body)
in (FStar_Util.format5 "%s(define-fun %s (%s) %s\n %s)" _198_541 f (FStar_String.concat " " binders) _198_540 _198_539)))))
end))
end
| Assume (t, c) -> begin
(let _198_543 = (caption_to_string c)
in (let _198_542 = (termToSmt t)
in (FStar_Util.format2 "%s(assert %s)" _198_543 _198_542)))
end
| Eval (t) -> begin
(let _198_544 = (termToSmt t)
in (FStar_Util.format1 "(eval %s)" _198_544))
end
| Echo (s) -> begin
(FStar_Util.format1 "(echo \"%s\")" s)
end
| CheckSat -> begin
"(check-sat)"
end
| Push -> begin
"(push)"
end
| Pop -> begin
"(pop)"
end))
and mkPrelude : Prims.string  ->  Prims.string = (fun z3options -> (let basic = (Prims.strcat z3options "(declare-sort Ref)\n(declare-fun Ref_constr_id (Ref) Int)\n\n(declare-sort String)\n(declare-fun String_constr_id (String) Int)\n\n(declare-sort Term)\n(declare-fun Term_constr_id (Term) Int)\n(declare-datatypes () ((Fuel \n(ZFuel) \n(SFuel (prec Fuel)))))\n(declare-fun MaxIFuel () Fuel)\n(declare-fun MaxFuel () Fuel)\n(declare-fun PreType (Term) Term)\n(declare-fun Valid (Term) Bool)\n(declare-fun HasTypeFuel (Fuel Term Term) Bool)\n(define-fun HasTypeZ ((x Term) (t Term)) Bool\n(HasTypeFuel ZFuel x t))\n(define-fun HasType ((x Term) (t Term)) Bool\n(HasTypeFuel MaxIFuel x t))\n;;fuel irrelevance\n(assert (forall ((f Fuel) (x Term) (t Term))\n(! (= (HasTypeFuel (SFuel f) x t)\n(HasTypeZ x t))\n:pattern ((HasTypeFuel (SFuel f) x t)))))\n(define-fun  IsTyped ((x Term)) Bool\n(exists ((t Term)) (HasTypeZ x t)))\n(declare-fun ApplyTF (Term Fuel) Term)\n(declare-fun ApplyTT (Term Term) Term)\n(declare-fun Rank (Term) Int)\n(declare-fun Closure (Term) Term)\n(declare-fun ConsTerm (Term Term) Term)\n(declare-fun ConsFuel (Fuel Term) Term)\n(declare-fun Precedes (Term Term) Term)\n(assert (forall ((t Term))\n(! (implies (exists ((e Term)) (HasType e t))\n(Valid t))\n:pattern ((Valid t)))))\n(assert (forall ((t1 Term) (t2 Term))\n(! (iff (Valid (Precedes t1 t2)) \n(< (Rank t1) (Rank t2)))\n:pattern ((Precedes t1 t2)))))\n(define-fun Prims.precedes ((a Term) (b Term) (t1 Term) (t2 Term)) Term\n(Precedes t1 t2))\n")
in (let constrs = (("String_const", (("String_const_proj_0", Int_sort))::[], String_sort, 0))::(("Tm_type", [], Term_sort, 0))::(("Tm_arrow", (("Tm_arrow_id", Int_sort))::[], Term_sort, 1))::(("Tm_app", (("Tm_app_fst", Term_sort))::(("Tm_app_snd", Term_sort))::[], Term_sort, 2))::(("Tm_uvar", (("Tm_uvar_fst", Int_sort))::[], Term_sort, 4))::(("Tm_unit", [], Term_sort, 0))::(("BoxInt", (("BoxInt_proj_0", Int_sort))::[], Term_sort, 1))::(("BoxBool", (("BoxBool_proj_0", Bool_sort))::[], Term_sort, 2))::(("BoxString", (("BoxString_proj_0", String_sort))::[], Term_sort, 3))::(("BoxRef", (("BoxRef_proj_0", Ref_sort))::[], Term_sort, 4))::(("Exp_uvar", (("Exp_uvar_fst", Int_sort))::[], Term_sort, 5))::(("LexCons", (("LexCons_0", Term_sort))::(("LexCons_1", Term_sort))::[], Term_sort, 6))::[]
in (let bcons = (let _198_547 = (let _198_546 = (FStar_All.pipe_right constrs (FStar_List.collect constructor_to_decl))
in (FStar_All.pipe_right _198_546 (FStar_List.map (declToSmt z3options))))
in (FStar_All.pipe_right _198_547 (FStar_String.concat "\n")))
in (let lex_ordering = "\n(define-fun is-Prims.LexCons ((t Term)) Bool \n(is-LexCons t))\n(assert (forall ((x1 Term) (x2 Term) (y1 Term) (y2 Term))\n(iff (Valid (Precedes (LexCons x1 x2) (LexCons y1 y2)))\n(or (Valid (Precedes x1 y1))\n(and (= x1 y1)\n(Valid (Precedes x2 y2)))))))\n"
in (Prims.strcat (Prims.strcat basic bcons) lex_ordering))))))

let mk_Term_type : term = (mkApp ("Tm_type", []))

let mk_Term_app : term  ->  term  ->  term = (fun t1 t2 -> (mkApp ("Tm_app", (t1)::(t2)::[])))

let mk_Term_uvar : Prims.int  ->  term = (fun i -> (let _198_556 = (let _198_555 = (let _198_554 = (mkInteger' i)
in (_198_554)::[])
in ("Tm_uvar", _198_555))
in (mkApp _198_556)))

let mk_Term_unit : term = (mkApp ("Tm_unit", []))

let boxInt : term  ->  term = (fun t -> (mkApp ("BoxInt", (t)::[])))

let unboxInt : term  ->  term = (fun t -> (mkApp ("BoxInt_proj_0", (t)::[])))

let boxBool : term  ->  term = (fun t -> (mkApp ("BoxBool", (t)::[])))

let unboxBool : term  ->  term = (fun t -> (mkApp ("BoxBool_proj_0", (t)::[])))

let boxString : term  ->  term = (fun t -> (mkApp ("BoxString", (t)::[])))

let unboxString : term  ->  term = (fun t -> (mkApp ("BoxString_proj_0", (t)::[])))

let boxRef : term  ->  term = (fun t -> (mkApp ("BoxRef", (t)::[])))

let unboxRef : term  ->  term = (fun t -> (mkApp ("BoxRef_proj_0", (t)::[])))

let boxTerm : sort  ->  term  ->  term = (fun sort t -> (match (sort) with
| Int_sort -> begin
(boxInt t)
end
| Bool_sort -> begin
(boxBool t)
end
| String_sort -> begin
(boxString t)
end
| Ref_sort -> begin
(boxRef t)
end
| _96_751 -> begin
(Prims.raise FStar_Util.Impos)
end))

let unboxTerm : sort  ->  term  ->  term = (fun sort t -> (match (sort) with
| Int_sort -> begin
(unboxInt t)
end
| Bool_sort -> begin
(unboxBool t)
end
| String_sort -> begin
(unboxString t)
end
| Ref_sort -> begin
(unboxRef t)
end
| _96_759 -> begin
(Prims.raise FStar_Util.Impos)
end))

let mk_PreType : term  ->  term = (fun t -> (mkApp ("PreType", (t)::[])))

let mk_Valid : term  ->  term = (fun t -> (match (t.tm) with
| App (Var ("Prims.b2t"), {tm = App (Var ("Prims.op_Equality"), _96_773::t1::t2::[]); hash = _96_767; freevars = _96_765}::[]) -> begin
(mkEq (t1, t2))
end
| App (Var ("Prims.b2t"), {tm = App (Var ("Prims.op_disEquality"), _96_792::t1::t2::[]); hash = _96_786; freevars = _96_784}::[]) -> begin
(let _198_585 = (mkEq (t1, t2))
in (mkNot _198_585))
end
| App (Var ("Prims.b2t"), {tm = App (Var ("Prims.op_LessThanOrEqual"), t1::t2::[]); hash = _96_805; freevars = _96_803}::[]) -> begin
(let _198_588 = (let _198_587 = (unboxInt t1)
in (let _198_586 = (unboxInt t2)
in (_198_587, _198_586)))
in (mkLTE _198_588))
end
| App (Var ("Prims.b2t"), {tm = App (Var ("Prims.op_LessThan"), t1::t2::[]); hash = _96_822; freevars = _96_820}::[]) -> begin
(let _198_591 = (let _198_590 = (unboxInt t1)
in (let _198_589 = (unboxInt t2)
in (_198_590, _198_589)))
in (mkLT _198_591))
end
| App (Var ("Prims.b2t"), {tm = App (Var ("Prims.op_GreaterThanOrEqual"), t1::t2::[]); hash = _96_839; freevars = _96_837}::[]) -> begin
(let _198_594 = (let _198_593 = (unboxInt t1)
in (let _198_592 = (unboxInt t2)
in (_198_593, _198_592)))
in (mkGTE _198_594))
end
| App (Var ("Prims.b2t"), {tm = App (Var ("Prims.op_GreaterThan"), t1::t2::[]); hash = _96_856; freevars = _96_854}::[]) -> begin
(let _198_597 = (let _198_596 = (unboxInt t1)
in (let _198_595 = (unboxInt t2)
in (_198_596, _198_595)))
in (mkGT _198_597))
end
| App (Var ("Prims.b2t"), {tm = App (Var ("Prims.op_AmpAmp"), t1::t2::[]); hash = _96_873; freevars = _96_871}::[]) -> begin
(let _198_600 = (let _198_599 = (unboxBool t1)
in (let _198_598 = (unboxBool t2)
in (_198_599, _198_598)))
in (mkAnd _198_600))
end
| App (Var ("Prims.b2t"), {tm = App (Var ("Prims.op_BarBar"), t1::t2::[]); hash = _96_890; freevars = _96_888}::[]) -> begin
(let _198_603 = (let _198_602 = (unboxBool t1)
in (let _198_601 = (unboxBool t2)
in (_198_602, _198_601)))
in (mkOr _198_603))
end
| App (Var ("Prims.b2t"), {tm = App (Var ("Prims.op_Negation"), t::[]); hash = _96_907; freevars = _96_905}::[]) -> begin
(let _198_604 = (unboxBool t)
in (mkNot _198_604))
end
| App (Var ("Prims.b2t"), t::[]) -> begin
(unboxBool t)
end
| _96_925 -> begin
(mkApp ("Valid", (t)::[]))
end))

let mk_HasType : term  ->  term  ->  term = (fun v t -> (mkApp ("HasType", (v)::(t)::[])))

let mk_HasTypeZ : term  ->  term  ->  term = (fun v t -> (mkApp ("HasTypeZ", (v)::(t)::[])))

let mk_IsTyped : term  ->  term = (fun v -> (mkApp ("IsTyped", (v)::[])))

let mk_HasTypeFuel : term  ->  term  ->  term  ->  term = (fun f v t -> if (FStar_ST.read FStar_Options.unthrottle_inductives) then begin
(mk_HasType v t)
end else begin
(mkApp ("HasTypeFuel", (f)::(v)::(t)::[]))
end)

let mk_HasTypeWithFuel : term Prims.option  ->  term  ->  term  ->  term = (fun f v t -> (match (f) with
| None -> begin
(mk_HasType v t)
end
| Some (f) -> begin
(mk_HasTypeFuel f v t)
end))

let mk_Destruct : term  ->  term = (fun v -> (mkApp ("Destruct", (v)::[])))

let mk_Rank : term  ->  term = (fun x -> (mkApp ("Rank", (x)::[])))

let mk_tester : Prims.string  ->  term  ->  term = (fun n t -> (mkApp ((Prims.strcat "is-" n), (t)::[])))

let mk_ApplyTF : term  ->  term  ->  term = (fun t t' -> (mkApp ("ApplyTF", (t)::(t')::[])))

let mk_ApplyTT : term  ->  term  ->  term = (fun t t' -> (mkApp ("ApplyTT", (t)::(t')::[])))

let mk_String_const : Prims.int  ->  term = (fun i -> (let _198_647 = (let _198_646 = (let _198_645 = (mkInteger' i)
in (_198_645)::[])
in ("String_const", _198_646))
in (mkApp _198_647)))

let mk_Precedes : term  ->  term  ->  term = (fun x1 x2 -> (let _198_652 = (mkApp ("Precedes", (x1)::(x2)::[]))
in (FStar_All.pipe_right _198_652 mk_Valid)))

let mk_LexCons : term  ->  term  ->  term = (fun x1 x2 -> (mkApp ("LexCons", (x1)::(x2)::[])))

let rec n_fuel : Prims.int  ->  term = (fun n -> if (n = 0) then begin
(mkApp ("ZFuel", []))
end else begin
(let _198_661 = (let _198_660 = (let _198_659 = (n_fuel (n - 1))
in (_198_659)::[])
in ("SFuel", _198_660))
in (mkApp _198_661))
end)

let fuel_2 : term = (n_fuel 2)

let fuel_100 : term = (n_fuel 100)

let mk_and_opt : term Prims.option  ->  term Prims.option  ->  term Prims.option = (fun p1 p2 -> (match ((p1, p2)) with
| (Some (p1), Some (p2)) -> begin
(let _198_666 = (mkAnd (p1, p2))
in Some (_198_666))
end
| ((Some (p), None)) | ((None, Some (p))) -> begin
Some (p)
end
| (None, None) -> begin
None
end))

let mk_and_opt_l : term Prims.option Prims.list  ->  term Prims.option = (fun pl -> (FStar_List.fold_left (fun out p -> (mk_and_opt p out)) None pl))

let mk_and_l : term Prims.list  ->  term = (fun l -> (match (l) with
| [] -> begin
mkTrue
end
| hd::tl -> begin
(FStar_List.fold_left (fun p1 p2 -> (mkAnd (p1, p2))) hd tl)
end))

let mk_or_l : term Prims.list  ->  term = (fun l -> (match (l) with
| [] -> begin
mkFalse
end
| hd::tl -> begin
(FStar_List.fold_left (fun p1 p2 -> (mkOr (p1, p2))) hd tl)
end))

let rec print_smt_term : term  ->  Prims.string = (fun t -> (match (t.tm) with
| Integer (n) -> begin
(FStar_Util.format1 "(Integer %s)" n)
end
| BoundV (n) -> begin
(let _198_683 = (FStar_Util.string_of_int n)
in (FStar_Util.format1 "(BoundV %s)" _198_683))
end
| FreeV (fv) -> begin
(FStar_Util.format1 "(FreeV %s)" (Prims.fst fv))
end
| App (op, l) -> begin
(let _198_684 = (print_smt_term_list l)
in (FStar_Util.format2 "(%s %s)" (op_to_string op) _198_684))
end
| Labeled (t, r1, r2) -> begin
(let _198_685 = (print_smt_term t)
in (FStar_Util.format2 "(Labeled \'%s\' %s)" r1 _198_685))
end
| Quant (qop, l, _96_1007, _96_1009, t) -> begin
(let _198_687 = (print_smt_term_list_list l)
in (let _198_686 = (print_smt_term t)
in (FStar_Util.format3 "(%s %s %s)" (qop_to_string qop) _198_687 _198_686)))
end))
and print_smt_term_list : term Prims.list  ->  Prims.string = (fun l -> (let _198_689 = (FStar_List.map print_smt_term l)
in (FStar_All.pipe_right _198_689 (FStar_String.concat " "))))
and print_smt_term_list_list : term Prims.list Prims.list  ->  Prims.string = (fun l -> (FStar_List.fold_left (fun s l -> (let _198_694 = (let _198_693 = (print_smt_term_list l)
in (Prims.strcat (Prims.strcat s "; [ ") _198_693))
in (Prims.strcat _198_694 " ] "))) "" l))



