
let eff_to_string = (fun _63_1 -> (match (_63_1) with
| FStar_Extraction_ML_Syntax.E_PURE -> begin
"Pure"
end
| FStar_Extraction_ML_Syntax.E_IMPURE -> begin
"Impure"
end))

let fail = (fun r msg -> (let _63_10 = (let _129_5 = (FStar_Absyn_Print.format_error r msg)
in (FStar_All.pipe_left FStar_Util.print_string _129_5))
in (FStar_All.exit 1)))

let err_uninst = (fun e -> (let _129_8 = (let _129_7 = (FStar_Absyn_Print.exp_to_string e)
in (FStar_Util.format1 "Variable %s has a polymorphic type; expected it to be fully instantiated" _129_7))
in (fail e.FStar_Absyn_Syntax.pos _129_8)))

let err_ill_typed_application = (fun e args t -> (let _129_14 = (let _129_13 = (FStar_Absyn_Print.exp_to_string e)
in (let _129_12 = (FStar_Absyn_Print.args_to_string args)
in (FStar_Util.format2 "Ill-typed application: application is %s \n remaining args are %s\n" _129_13 _129_12)))
in (fail e.FStar_Absyn_Syntax.pos _129_14)))

let err_value_restriction = (fun e -> (fail e.FStar_Absyn_Syntax.pos "Refusing to generalize because of the value restriction"))

let err_unexpected_eff = (fun e f0 f1 -> (let _129_20 = (let _129_19 = (FStar_Absyn_Print.exp_to_string e)
in (FStar_Util.format3 "for expression %s, Expected effect %s; got effect %s" _129_19 (eff_to_string f0) (eff_to_string f1)))
in (fail e.FStar_Absyn_Syntax.pos _129_20)))

let is_constructor = (fun e -> (match ((let _129_23 = (FStar_Absyn_Util.compress_exp e)
in _129_23.FStar_Absyn_Syntax.n)) with
| (FStar_Absyn_Syntax.Exp_fvar (_, Some (FStar_Absyn_Syntax.Data_ctor))) | (FStar_Absyn_Syntax.Exp_fvar (_, Some (FStar_Absyn_Syntax.Record_ctor (_)))) -> begin
true
end
| _63_36 -> begin
false
end))

let rec is_value_or_type_app = (fun e -> (match ((let _129_26 = (FStar_Absyn_Util.compress_exp e)
in _129_26.FStar_Absyn_Syntax.n)) with
| (FStar_Absyn_Syntax.Exp_constant (_)) | (FStar_Absyn_Syntax.Exp_bvar (_)) | (FStar_Absyn_Syntax.Exp_fvar (_)) | (FStar_Absyn_Syntax.Exp_abs (_)) -> begin
true
end
| FStar_Absyn_Syntax.Exp_app (head, args) -> begin
(match ((is_constructor head)) with
| true -> begin
(FStar_All.pipe_right args (FStar_List.for_all (fun _63_57 -> (match (_63_57) with
| (te, _63_56) -> begin
(match (te) with
| FStar_Util.Inl (_63_59) -> begin
true
end
| FStar_Util.Inr (e) -> begin
(is_value_or_type_app e)
end)
end))))
end
| false -> begin
(match ((let _129_28 = (FStar_Absyn_Util.compress_exp head)
in _129_28.FStar_Absyn_Syntax.n)) with
| (FStar_Absyn_Syntax.Exp_bvar (_)) | (FStar_Absyn_Syntax.Exp_fvar (_)) -> begin
(FStar_All.pipe_right args (FStar_List.for_all (fun _63_2 -> (match (_63_2) with
| (FStar_Util.Inl (te), _63_73) -> begin
true
end
| _63_76 -> begin
false
end))))
end
| _63_78 -> begin
false
end)
end)
end
| (FStar_Absyn_Syntax.Exp_meta (FStar_Absyn_Syntax.Meta_desugared (e, _))) | (FStar_Absyn_Syntax.Exp_ascribed (e, _, _)) -> begin
(is_value_or_type_app e)
end
| _63_92 -> begin
false
end))

let rec is_ml_value = (fun e -> (match (e) with
| (FStar_Extraction_ML_Syntax.MLE_Const (_)) | (FStar_Extraction_ML_Syntax.MLE_Var (_)) | (FStar_Extraction_ML_Syntax.MLE_Name (_)) | (FStar_Extraction_ML_Syntax.MLE_Fun (_)) -> begin
true
end
| (FStar_Extraction_ML_Syntax.MLE_CTor (_, exps)) | (FStar_Extraction_ML_Syntax.MLE_Tuple (exps)) -> begin
(FStar_Util.for_all is_ml_value exps)
end
| FStar_Extraction_ML_Syntax.MLE_Record (_63_113, fields) -> begin
(FStar_Util.for_all (fun _63_120 -> (match (_63_120) with
| (_63_118, e) -> begin
(is_ml_value e)
end)) fields)
end
| _63_122 -> begin
false
end))

let translate_typ = (fun g t -> (let _129_37 = (FStar_Extraction_ML_ExtractTyp.extractTyp g t)
in (FStar_Extraction_ML_Util.eraseTypeDeep g _129_37)))

let translate_typ_of_arg = (fun g a -> (let _129_42 = (FStar_Extraction_ML_ExtractTyp.getTypeFromArg g a)
in (FStar_Extraction_ML_Util.eraseTypeDeep g _129_42)))

let instantiate = (fun s args -> (FStar_Extraction_ML_Util.subst s args))

let erasable = (fun g f t -> ((f = FStar_Extraction_ML_Syntax.E_PURE) && (FStar_Extraction_ML_Util.erasableType g t)))

let erase = (fun g e f t -> (match ((erasable g f t)) with
| true -> begin
(let _63_137 = (FStar_Extraction_ML_Env.debug g (fun _63_136 -> (match (()) with
| () -> begin
(let _129_63 = (FStar_Extraction_OCaml_Code.string_of_mlexpr g e)
in (let _129_62 = (FStar_Extraction_OCaml_Code.string_of_mlty g t)
in (FStar_Util.fprint2 "Erasing %s at type %s\n" _129_63 _129_62)))
end)))
in (FStar_Extraction_ML_Syntax.ml_unit, f, FStar_Extraction_ML_Env.erasedContent))
end
| false -> begin
(e, f, t)
end))

let maybe_coerce = (fun g e tInferred etag tExpected -> (match ((FStar_Extraction_ML_Util.equiv g tInferred tExpected)) with
| true -> begin
e
end
| false -> begin
FStar_Extraction_ML_Syntax.MLE_Coerce ((e, tInferred, tExpected))
end))

let eff_leq = (fun f f' -> (match ((f, f')) with
| ((FStar_Extraction_ML_Syntax.E_PURE, _)) | ((_, FStar_Extraction_ML_Syntax.E_IMPURE)) -> begin
true
end
| _63_155 -> begin
false
end))

let join = (fun f f' -> (match ((f, f')) with
| ((FStar_Extraction_ML_Syntax.E_IMPURE, _)) | ((_, FStar_Extraction_ML_Syntax.E_IMPURE)) -> begin
FStar_Extraction_ML_Syntax.E_IMPURE
end
| _63_167 -> begin
FStar_Extraction_ML_Syntax.E_PURE
end))

let join_l = (fun fs -> (FStar_List.fold_left join FStar_Extraction_ML_Syntax.E_PURE fs))

let extract_pat = (fun g p -> (let rec extract_pat = (fun disj imp g p -> (match (p.FStar_Absyn_Syntax.v) with
| FStar_Absyn_Syntax.Pat_disj ([]) -> begin
(FStar_All.failwith "Impossible")
end
| FStar_Absyn_Syntax.Pat_disj (p::pats) -> begin
(let _63_184 = (extract_pat true false g p)
in (match (_63_184) with
| (g, p) -> begin
(let _129_101 = (let _129_100 = (let _129_99 = (let _129_98 = (FStar_List.collect (fun x -> (let _129_97 = (extract_pat true false g x)
in (Prims.snd _129_97))) pats)
in (FStar_List.append p _129_98))
in FStar_Extraction_ML_Syntax.MLP_Branch (_129_99))
in (_129_100)::[])
in (g, _129_101))
end))
end
| FStar_Absyn_Syntax.Pat_constant (s) -> begin
(let _129_104 = (let _129_103 = (let _129_102 = (FStar_Extraction_ML_Util.mlconst_of_const s)
in FStar_Extraction_ML_Syntax.MLP_Const (_129_102))
in (_129_103)::[])
in (g, _129_104))
end
| FStar_Absyn_Syntax.Pat_cons (f, q, pats) -> begin
(let _63_201 = (match ((FStar_Extraction_ML_Env.lookup_fv g f)) with
| (FStar_Extraction_ML_Syntax.MLE_Name (n), ttys) -> begin
(n, ttys)
end
| _63_198 -> begin
(FStar_All.failwith "Expected a constructor")
end)
in (match (_63_201) with
| (d, tys) -> begin
(let nTyVars = (FStar_List.length (Prims.fst tys))
in (let _63_205 = (FStar_Util.first_N nTyVars pats)
in (match (_63_205) with
| (tysVarPats, restPats) -> begin
(let _63_212 = (FStar_Util.fold_map (fun g _63_209 -> (match (_63_209) with
| (p, imp) -> begin
(extract_pat disj true g p)
end)) g tysVarPats)
in (match (_63_212) with
| (g, tyMLPats) -> begin
(let _63_219 = (FStar_Util.fold_map (fun g _63_216 -> (match (_63_216) with
| (p, imp) -> begin
(extract_pat disj false g p)
end)) g restPats)
in (match (_63_219) with
| (g, restMLPats) -> begin
(let mlPats = (FStar_List.append tyMLPats restMLPats)
in (let _129_110 = (let _129_109 = (FStar_All.pipe_left (FStar_Extraction_ML_Util.resugar_pat q) (FStar_Extraction_ML_Syntax.MLP_CTor ((d, (FStar_List.flatten mlPats)))))
in (_129_109)::[])
in (g, _129_110)))
end))
end))
end)))
end))
end
| FStar_Absyn_Syntax.Pat_var (x) -> begin
(let mlty = (translate_typ g x.FStar_Absyn_Syntax.sort)
in (let g = (FStar_Extraction_ML_Env.extend_bv g x ([], mlty) false imp)
in (g, (match (imp) with
| true -> begin
[]
end
| false -> begin
(FStar_Extraction_ML_Syntax.MLP_Var ((FStar_Extraction_ML_Syntax.as_mlident x.FStar_Absyn_Syntax.v)))::[]
end))))
end
| FStar_Absyn_Syntax.Pat_wild (x) when disj -> begin
(g, (FStar_Extraction_ML_Syntax.MLP_Wild)::[])
end
| FStar_Absyn_Syntax.Pat_wild (x) -> begin
(let mlty = (translate_typ g x.FStar_Absyn_Syntax.sort)
in (let g = (FStar_Extraction_ML_Env.extend_bv g x ([], mlty) false imp)
in (g, (match (imp) with
| true -> begin
[]
end
| false -> begin
(FStar_Extraction_ML_Syntax.MLP_Var ((FStar_Extraction_ML_Syntax.as_mlident x.FStar_Absyn_Syntax.v)))::[]
end))))
end
| FStar_Absyn_Syntax.Pat_dot_term (_63_232) -> begin
(g, (FStar_Extraction_ML_Syntax.MLP_Wild)::[])
end
| FStar_Absyn_Syntax.Pat_tvar (a) -> begin
(let mlty = FStar_Extraction_ML_Syntax.MLTY_Top
in (let g = (FStar_Extraction_ML_Env.extend_ty g a (Some (mlty)))
in (g, (match (imp) with
| true -> begin
[]
end
| false -> begin
(FStar_Extraction_ML_Syntax.MLP_Wild)::[]
end))))
end
| (FStar_Absyn_Syntax.Pat_dot_typ (_)) | (FStar_Absyn_Syntax.Pat_twild (_)) -> begin
(g, [])
end))
in (extract_pat false false g p)))

let normalize_abs = (fun e0 -> (let rec aux = (fun bs e -> (let e = (FStar_Absyn_Util.compress_exp e)
in (match (e.FStar_Absyn_Syntax.n) with
| FStar_Absyn_Syntax.Exp_abs (bs', body) -> begin
(aux (FStar_List.append bs bs') body)
end
| _63_254 -> begin
(let e' = (FStar_Absyn_Util.unascribe e)
in (match ((FStar_Absyn_Util.is_fun e')) with
| true -> begin
(aux bs e')
end
| false -> begin
(FStar_Absyn_Syntax.mk_Exp_abs (bs, e) None e0.FStar_Absyn_Syntax.pos)
end))
end)))
in (aux [] e0)))

let ffi_mltuple_mlp = (fun n -> (let name = (match (((2 < n) && (n < 6))) with
| true -> begin
(let _129_119 = (FStar_Util.string_of_int n)
in (Prims.strcat "mktuple" _129_119))
end
| false -> begin
(match ((n = 2)) with
| true -> begin
"mkpair"
end
| false -> begin
(FStar_All.failwith "NYI in runtime/allocator/camlstack.mli")
end)
end)
in (("Camlstack")::[], name)))

let fix_lalloc = (fun arg -> (match (arg) with
| FStar_Extraction_ML_Syntax.MLE_Tuple (args) -> begin
(FStar_All.failwith "unexpected. Prims.TupleN is not specially handled yet. So, F* tuples, which are sugar forPrims.TupleN,  were expected to be extracted as MLE_CTor")
end
| FStar_Extraction_ML_Syntax.MLE_Record (mlns, fields) -> begin
(let args = (FStar_List.map Prims.snd fields)
in (let tup = (let _129_124 = (let _129_123 = (let _129_122 = (ffi_mltuple_mlp (FStar_List.length args))
in FStar_Extraction_ML_Syntax.MLE_Name (_129_122))
in (_129_123, args))
in FStar_Extraction_ML_Syntax.MLE_App (_129_124))
in (let dummyTy = FStar_Extraction_ML_Syntax.ml_unit_ty
in FStar_Extraction_ML_Syntax.MLE_Coerce ((tup, dummyTy, dummyTy)))))
end
| FStar_Extraction_ML_Syntax.MLE_CTor (mlp, args) -> begin
(FStar_All.failwith "NYI: lalloc ctor")
end
| _63_273 -> begin
(FStar_All.failwith "for efficiency, the argument to lalloc should be a head normal form of the type. Extraction will then avoid creating this value on the heap.")
end))

let maybe_lalloc_eta_data = (fun g qual residualType mlAppExpr -> (let rec eta_args = (fun more_args t -> (match (t) with
| FStar_Extraction_ML_Syntax.MLTY_Fun (t0, _63_283, t1) -> begin
(let x = (let _129_137 = (FStar_Absyn_Util.gensym ())
in (_129_137, (- (1))))
in (eta_args ((((x, Some (t0)), FStar_Extraction_ML_Syntax.MLE_Var (x)))::more_args) t1))
end
| FStar_Extraction_ML_Syntax.MLTY_Named (_63_289, _63_291) -> begin
(FStar_List.rev more_args)
end
| _63_295 -> begin
(FStar_All.failwith "Impossible")
end))
in (let as_record = (fun qual e -> (match ((e, qual)) with
| (FStar_Extraction_ML_Syntax.MLE_CTor (_63_300, args), Some (FStar_Absyn_Syntax.Record_ctor (_63_305, fields))) -> begin
(let path = (FStar_Extraction_ML_Util.record_field_path fields)
in (let fields = (FStar_Extraction_ML_Util.record_fields fields args)
in FStar_Extraction_ML_Syntax.MLE_Record ((path, fields))))
end
| _63_314 -> begin
e
end))
in (let resugar_and_maybe_eta = (fun qual e -> (let eargs = (eta_args [] residualType)
in (match (eargs) with
| [] -> begin
(let _129_146 = (as_record qual e)
in (FStar_Extraction_ML_Util.resugar_exp _129_146))
end
| _63_321 -> begin
(let _63_324 = (FStar_List.unzip eargs)
in (match (_63_324) with
| (binders, eargs) -> begin
(match (e) with
| FStar_Extraction_ML_Syntax.MLE_CTor (head, args) -> begin
(let body = (let _129_147 = (FStar_All.pipe_left (as_record qual) (FStar_Extraction_ML_Syntax.MLE_CTor ((head, (FStar_List.append args eargs)))))
in (FStar_All.pipe_left FStar_Extraction_ML_Util.resugar_exp _129_147))
in FStar_Extraction_ML_Syntax.MLE_Fun ((binders, body)))
end
| _63_331 -> begin
(FStar_All.failwith "Impossible")
end)
end))
end)))
in (match ((mlAppExpr, qual)) with
| (FStar_Extraction_ML_Syntax.MLE_App (FStar_Extraction_ML_Syntax.MLE_Name (mlp), mlarg::[]), _63_339) when (mlp = FStar_Extraction_ML_Syntax.mlp_lalloc) -> begin
(let _63_342 = (FStar_Extraction_ML_Env.debug g (fun _63_341 -> (match (()) with
| () -> begin
(FStar_Util.print_string "need to do lalloc surgery here\n")
end)))
in (fix_lalloc mlarg))
end
| (_63_345, None) -> begin
mlAppExpr
end
| (FStar_Extraction_ML_Syntax.MLE_App (FStar_Extraction_ML_Syntax.MLE_Name (mlp), mle::args), Some (FStar_Absyn_Syntax.Record_projector (f))) -> begin
(let fn = (FStar_Extraction_ML_Util.mlpath_of_lid f)
in (let proj = FStar_Extraction_ML_Syntax.MLE_Proj ((mle, fn))
in (match (args) with
| [] -> begin
proj
end
| _63_363 -> begin
FStar_Extraction_ML_Syntax.MLE_App ((proj, args))
end)))
end
| ((FStar_Extraction_ML_Syntax.MLE_App (FStar_Extraction_ML_Syntax.MLE_Name (mlp), mlargs), Some (FStar_Absyn_Syntax.Data_ctor))) | ((FStar_Extraction_ML_Syntax.MLE_App (FStar_Extraction_ML_Syntax.MLE_Name (mlp), mlargs), Some (FStar_Absyn_Syntax.Record_ctor (_)))) -> begin
(FStar_All.pipe_left (resugar_and_maybe_eta qual) (FStar_Extraction_ML_Syntax.MLE_CTor ((mlp, mlargs))))
end
| ((FStar_Extraction_ML_Syntax.MLE_Name (mlp), Some (FStar_Absyn_Syntax.Data_ctor))) | ((FStar_Extraction_ML_Syntax.MLE_Name (mlp), Some (FStar_Absyn_Syntax.Record_ctor (_)))) -> begin
(FStar_All.pipe_left (resugar_and_maybe_eta qual) (FStar_Extraction_ML_Syntax.MLE_CTor ((mlp, []))))
end
| _63_392 -> begin
mlAppExpr
end)))))

let rec check_exp = (fun g e f t -> (let _63_402 = (let _129_165 = (check_exp' g e f t)
in (erase g _129_165 f t))
in (match (_63_402) with
| (e, _63_399, _63_401) -> begin
e
end)))
and check_exp' = (fun g e f t -> (match ((let _129_170 = (FStar_Absyn_Util.compress_exp e)
in _129_170.FStar_Absyn_Syntax.n)) with
| FStar_Absyn_Syntax.Exp_match (scrutinee, pats) -> begin
(let _63_414 = (synth_exp g scrutinee)
in (match (_63_414) with
| (e, f_e, t_e) -> begin
(let mlbranches = (FStar_All.pipe_right pats (FStar_List.map (fun _63_418 -> (match (_63_418) with
| (pat, when_opt, branch) -> begin
(let _63_421 = (extract_pat g pat)
in (match (_63_421) with
| (env, p) -> begin
(let when_opt = (match (when_opt) with
| None -> begin
None
end
| Some (w) -> begin
(let _129_172 = (check_exp env w FStar_Extraction_ML_Syntax.E_IMPURE FStar_Extraction_ML_Syntax.ml_bool_ty)
in Some (_129_172))
end)
in (let branch = (check_exp env branch f t)
in (let _129_173 = (FStar_List.hd p)
in (_129_173, when_opt, branch))))
end))
end))))
in (match ((eff_leq f_e f)) with
| true -> begin
FStar_Extraction_ML_Syntax.MLE_Match ((e, mlbranches))
end
| false -> begin
(err_unexpected_eff scrutinee f f_e)
end))
end))
end
| _63_429 -> begin
(let _63_433 = (synth_exp g e)
in (match (_63_433) with
| (e0, f0, t0) -> begin
(match ((eff_leq f0 f)) with
| true -> begin
(maybe_coerce g e0 t0 f t)
end
| false -> begin
(err_unexpected_eff e f f0)
end)
end))
end))
and synth_exp = (fun g e -> (let _63_439 = (synth_exp' g e)
in (match (_63_439) with
| (e, f, t) -> begin
(erase g e f t)
end)))
and synth_exp' = (fun g e -> (let _63_443 = (FStar_Extraction_ML_Env.debug g (fun u -> (let _129_180 = (let _129_179 = (FStar_Absyn_Print.exp_to_string e)
in (FStar_Util.format1 "now synthesizing expression :  %s \n" _129_179))
in (FStar_Util.print_string _129_180))))
in (match ((let _129_181 = (FStar_Absyn_Util.compress_exp e)
in _129_181.FStar_Absyn_Syntax.n)) with
| FStar_Absyn_Syntax.Exp_constant (c) -> begin
(let t = (FStar_Tc_Recheck.typing_const e.FStar_Absyn_Syntax.pos c)
in (let _129_185 = (let _129_183 = (FStar_Extraction_ML_Util.mlconst_of_const c)
in (FStar_All.pipe_left (fun _129_182 -> FStar_Extraction_ML_Syntax.MLE_Const (_129_182)) _129_183))
in (let _129_184 = (translate_typ g t)
in (_129_185, FStar_Extraction_ML_Syntax.E_PURE, _129_184))))
end
| FStar_Absyn_Syntax.Exp_ascribed (e0, t, f) -> begin
(let t = (translate_typ g t)
in (let f = (match (f) with
| None -> begin
(FStar_All.failwith "Ascription node with an empty effect label")
end
| Some (l) -> begin
(FStar_Extraction_ML_ExtractTyp.translate_eff g l)
end)
in (let e = (check_exp g e0 f t)
in (e, f, t))))
end
| (FStar_Absyn_Syntax.Exp_bvar (_)) | (FStar_Absyn_Syntax.Exp_fvar (_)) -> begin
(let _63_469 = (FStar_Extraction_ML_Env.lookup_var g e)
in (match (_63_469) with
| ((x, mltys), qual) -> begin
(match (mltys) with
| ([], t) -> begin
(let _129_186 = (maybe_lalloc_eta_data g qual t x)
in (_129_186, FStar_Extraction_ML_Syntax.E_PURE, t))
end
| _63_474 -> begin
(err_uninst e)
end)
end))
end
| FStar_Absyn_Syntax.Exp_app (head, args) -> begin
(let rec synth_app = (fun is_data _63_483 _63_486 restArgs -> (match ((_63_483, _63_486)) with
| ((mlhead, mlargs_f), (f, t)) -> begin
(match ((restArgs, t)) with
| ([], _63_490) -> begin
(let _63_501 = (match (((FStar_Absyn_Util.is_primop head) || (FStar_Extraction_ML_Util.codegen_fsharp ()))) with
| true -> begin
(let _129_195 = (FStar_All.pipe_right (FStar_List.rev mlargs_f) (FStar_List.map Prims.fst))
in ([], _129_195))
end
| false -> begin
(FStar_List.fold_left (fun _63_494 _63_497 -> (match ((_63_494, _63_497)) with
| ((lbs, out_args), (arg, f)) -> begin
(match ((f = FStar_Extraction_ML_Syntax.E_PURE)) with
| true -> begin
(lbs, (arg)::out_args)
end
| false -> begin
(let x = (let _129_198 = (FStar_Absyn_Util.gensym ())
in (_129_198, (- (1))))
in (((x, arg))::lbs, (FStar_Extraction_ML_Syntax.MLE_Var (x))::out_args))
end)
end)) ([], []) mlargs_f)
end)
in (match (_63_501) with
| (lbs, mlargs) -> begin
(let app = (FStar_All.pipe_left (maybe_lalloc_eta_data g is_data t) (FStar_Extraction_ML_Syntax.MLE_App ((mlhead, mlargs))))
in (let l_app = (FStar_List.fold_right (fun _63_505 out -> (match (_63_505) with
| (x, arg) -> begin
FStar_Extraction_ML_Syntax.MLE_Let (((false, ({FStar_Extraction_ML_Syntax.mllb_name = x; FStar_Extraction_ML_Syntax.mllb_tysc = None; FStar_Extraction_ML_Syntax.mllb_add_unit = false; FStar_Extraction_ML_Syntax.mllb_def = arg})::[]), out))
end)) lbs app)
in (l_app, f, t)))
end))
end
| ((FStar_Util.Inl (_63_510), _63_513)::rest, FStar_Extraction_ML_Syntax.MLTY_Fun (tunit, f', t)) -> begin
(match ((FStar_Extraction_ML_Util.equiv g tunit FStar_Extraction_ML_Syntax.ml_unit_ty)) with
| true -> begin
(synth_app is_data (mlhead, ((FStar_Extraction_ML_Syntax.ml_unit, FStar_Extraction_ML_Syntax.E_PURE))::mlargs_f) ((join f f'), t) rest)
end
| false -> begin
(FStar_All.failwith "Impossible: ill-typed application")
end)
end
| ((FStar_Util.Inr (e0), _63_526)::rest, FStar_Extraction_ML_Syntax.MLTY_Fun (tExpected, f', t)) -> begin
(let _63_538 = (synth_exp g e0)
in (match (_63_538) with
| (e0, f0, tInferred) -> begin
(let e0 = (maybe_coerce g e0 tInferred f' tExpected)
in (let _129_202 = (let _129_201 = (join_l ((f)::(f')::(f0)::[]))
in (_129_201, t))
in (synth_app is_data (mlhead, ((e0, f0))::mlargs_f) _129_202 rest)))
end))
end
| _63_541 -> begin
(match ((FStar_Extraction_ML_Util.delta_unfold g t)) with
| Some (t) -> begin
(synth_app is_data (mlhead, mlargs_f) (f, t) restArgs)
end
| None -> begin
(err_ill_typed_application e restArgs t)
end)
end)
end))
in (let head = (FStar_Absyn_Util.compress_exp head)
in (match (head.FStar_Absyn_Syntax.n) with
| (FStar_Absyn_Syntax.Exp_bvar (_)) | (FStar_Absyn_Syntax.Exp_fvar (_)) -> begin
(let _63_558 = (FStar_Extraction_ML_Env.lookup_var g head)
in (match (_63_558) with
| ((head, (vars, t)), qual) -> begin
(let n = (FStar_List.length vars)
in (match ((n <= (FStar_List.length args))) with
| true -> begin
(let _63_562 = (FStar_Util.first_N n args)
in (match (_63_562) with
| (prefix, rest) -> begin
(let prefixAsMLTypes = (FStar_List.map (translate_typ_of_arg g) prefix)
in (let t0 = t
in (let t = (instantiate (vars, t) prefixAsMLTypes)
in (match (rest) with
| [] -> begin
(let _129_203 = (maybe_lalloc_eta_data g qual t head)
in (_129_203, FStar_Extraction_ML_Syntax.E_PURE, t))
end
| _63_568 -> begin
(synth_app qual (head, []) (FStar_Extraction_ML_Syntax.E_PURE, t) rest)
end))))
end))
end
| false -> begin
(err_uninst e)
end))
end))
end
| _63_570 -> begin
(let _63_574 = (synth_exp g head)
in (match (_63_574) with
| (head, f, t) -> begin
(synth_app None (head, []) (f, t) args)
end))
end)))
end
| FStar_Absyn_Syntax.Exp_abs (bs, body) -> begin
(let _63_597 = (FStar_List.fold_left (fun _63_581 _63_585 -> (match ((_63_581, _63_585)) with
| ((ml_bs, env), (b, _63_584)) -> begin
(match (b) with
| FStar_Util.Inl (a) -> begin
(let env = (FStar_Extraction_ML_Env.extend_ty env a (Some (FStar_Extraction_ML_Syntax.MLTY_Top)))
in (let ml_b = (let _129_208 = (FStar_Extraction_ML_Env.btvar_as_mlTermVar a)
in (let _129_207 = (FStar_All.pipe_left (fun _129_206 -> Some (_129_206)) FStar_Extraction_ML_Syntax.ml_unit_ty)
in (_129_208, _129_207)))
in ((ml_b)::ml_bs, env)))
end
| FStar_Util.Inr (x) -> begin
(let t = (translate_typ env x.FStar_Absyn_Syntax.sort)
in (let env = (FStar_Extraction_ML_Env.extend_bv env x ([], t) false false)
in (let ml_b = ((FStar_Extraction_ML_Syntax.as_mlident x.FStar_Absyn_Syntax.v), Some (t))
in ((ml_b)::ml_bs, env))))
end)
end)) ([], g) bs)
in (match (_63_597) with
| (ml_bs, env) -> begin
(let ml_bs = (FStar_List.rev ml_bs)
in (let _63_602 = (synth_exp env body)
in (match (_63_602) with
| (ml_body, f, t) -> begin
(let _63_612 = (FStar_List.fold_right (fun _63_606 _63_609 -> (match ((_63_606, _63_609)) with
| ((_63_604, targ), (f, t)) -> begin
(let _129_213 = (let _129_212 = (let _129_211 = (FStar_Util.must targ)
in (_129_211, f, t))
in FStar_Extraction_ML_Syntax.MLTY_Fun (_129_212))
in (FStar_Extraction_ML_Syntax.E_PURE, _129_213))
end)) ml_bs (f, t))
in (match (_63_612) with
| (f, tfun) -> begin
(FStar_Extraction_ML_Syntax.MLE_Fun ((ml_bs, ml_body)), f, tfun)
end))
end)))
end))
end
| FStar_Absyn_Syntax.Exp_let ((is_rec, lbs), e') -> begin
(let maybe_generalize = (fun _63_624 -> (match (_63_624) with
| {FStar_Absyn_Syntax.lbname = lbname; FStar_Absyn_Syntax.lbtyp = t; FStar_Absyn_Syntax.lbeff = lbeff; FStar_Absyn_Syntax.lbdef = e} -> begin
(let f_e = (FStar_Extraction_ML_ExtractTyp.translate_eff g lbeff)
in (let t = (FStar_Absyn_Util.compress_typ t)
in (match (t.FStar_Absyn_Syntax.n) with
| FStar_Absyn_Syntax.Typ_fun (bs, c) when (FStar_Extraction_ML_Util.is_type_abstraction bs) -> begin
(let _63_648 = (match ((FStar_Util.prefix_until (fun _63_3 -> (match (_63_3) with
| (FStar_Util.Inr (_63_633), _63_636) -> begin
true
end
| _63_639 -> begin
false
end)) bs)) with
| None -> begin
(bs, (FStar_Absyn_Util.comp_result c))
end
| Some (bs, b, rest) -> begin
(let _129_217 = (FStar_Absyn_Syntax.mk_Typ_fun ((b)::rest, c) None c.FStar_Absyn_Syntax.pos)
in (bs, _129_217))
end)
in (match (_63_648) with
| (tbinders, tbody) -> begin
(let n = (FStar_List.length tbinders)
in (let e = (normalize_abs e)
in (match (e.FStar_Absyn_Syntax.n) with
| FStar_Absyn_Syntax.Exp_abs (bs, body) -> begin
(match ((n <= (FStar_List.length bs))) with
| true -> begin
(let _63_657 = (FStar_Util.first_N n bs)
in (match (_63_657) with
| (targs, rest_args) -> begin
(let expected_t = (match ((FStar_Absyn_Util.mk_subst_binder targs tbinders)) with
| None -> begin
(FStar_All.failwith "Not enough type binders in the body of the let expression")
end
| Some (s) -> begin
(FStar_Absyn_Util.subst_typ s tbody)
end)
in (let targs = (FStar_All.pipe_right targs (FStar_List.map (fun _63_4 -> (match (_63_4) with
| (FStar_Util.Inl (a), _63_666) -> begin
a
end
| _63_669 -> begin
(FStar_All.failwith "Impossible")
end))))
in (let env = (FStar_List.fold_left (fun env a -> (FStar_Extraction_ML_Env.extend_ty env a None)) g targs)
in (let expected_t = (translate_typ env expected_t)
in (let polytype = (let _129_221 = (FStar_All.pipe_right targs (FStar_List.map FStar_Extraction_ML_Env.btvar_as_mltyvar))
in (_129_221, expected_t))
in (let add_unit = (match (rest_args) with
| [] -> begin
(not ((is_value_or_type_app body)))
end
| _63_678 -> begin
false
end)
in (let rest_args = (match (add_unit) with
| true -> begin
(FStar_Extraction_ML_Util.unit_binder)::rest_args
end
| false -> begin
rest_args
end)
in (let body = (match (rest_args) with
| [] -> begin
body
end
| _63_683 -> begin
(FStar_Absyn_Syntax.mk_Exp_abs (rest_args, body) None e.FStar_Absyn_Syntax.pos)
end)
in (lbname, f_e, (t, (targs, polytype)), add_unit, body)))))))))
end))
end
| false -> begin
(FStar_All.failwith "Not enough type binders")
end)
end
| _63_686 -> begin
(err_value_restriction e)
end)))
end))
end
| _63_688 -> begin
(let expected_t = (translate_typ g t)
in (lbname, f_e, (t, ([], ([], expected_t))), false, e))
end)))
end))
in (let check_lb = (fun env _63_703 -> (match (_63_703) with
| (nm, (lbname, f, (t, (targs, polytype)), add_unit, e)) -> begin
(let env = (FStar_List.fold_left (fun env a -> (FStar_Extraction_ML_Env.extend_ty env a None)) env targs)
in (let expected_t = (match (add_unit) with
| true -> begin
FStar_Extraction_ML_Syntax.MLTY_Fun ((FStar_Extraction_ML_Syntax.ml_unit_ty, FStar_Extraction_ML_Syntax.E_PURE, (Prims.snd polytype)))
end
| false -> begin
(Prims.snd polytype)
end)
in (let e = (check_exp env e f expected_t)
in (f, {FStar_Extraction_ML_Syntax.mllb_name = nm; FStar_Extraction_ML_Syntax.mllb_tysc = Some (polytype); FStar_Extraction_ML_Syntax.mllb_add_unit = add_unit; FStar_Extraction_ML_Syntax.mllb_def = e}))))
end))
in (let lbs = (FStar_All.pipe_right lbs (FStar_List.map maybe_generalize))
in (let _63_732 = (FStar_List.fold_right (fun lb _63_713 -> (match (_63_713) with
| (env, lbs) -> begin
(let _63_726 = lb
in (match (_63_726) with
| (lbname, _63_716, (t, (_63_719, polytype)), add_unit, _63_725) -> begin
(let _63_729 = (FStar_Extraction_ML_Env.extend_lb env lbname t polytype add_unit)
in (match (_63_729) with
| (env, nm) -> begin
(env, ((nm, lb))::lbs)
end))
end))
end)) lbs (g, []))
in (match (_63_732) with
| (env_body, lbs) -> begin
(let env_def = (match (is_rec) with
| true -> begin
env_body
end
| false -> begin
g
end)
in (let lbs = (FStar_All.pipe_right lbs (FStar_List.map (check_lb env_def)))
in (let _63_738 = (synth_exp env_body e')
in (match (_63_738) with
| (e', f', t') -> begin
(let f = (let _129_231 = (let _129_230 = (FStar_List.map Prims.fst lbs)
in (f')::_129_230)
in (join_l _129_231))
in (let _129_235 = (let _129_234 = (let _129_233 = (let _129_232 = (FStar_List.map Prims.snd lbs)
in (is_rec, _129_232))
in (_129_233, e'))
in FStar_Extraction_ML_Syntax.MLE_Let (_129_234))
in (_129_235, f, t')))
end))))
end)))))
end
| FStar_Absyn_Syntax.Exp_match (e, pats) -> begin
(FStar_All.failwith "Matches must be checked; missing a compiler-provided annotation")
end
| FStar_Absyn_Syntax.Exp_meta (FStar_Absyn_Syntax.Meta_desugared (e, _63_746)) -> begin
(synth_exp g e)
end
| (FStar_Absyn_Syntax.Exp_uvar (_)) | (FStar_Absyn_Syntax.Exp_delayed (_)) -> begin
(FStar_All.failwith "Unexpected expression")
end)))

let fresh = (let c = (FStar_Util.mk_ref 0)
in (fun x -> (let _63_758 = (FStar_Util.incr c)
in (let _129_238 = (FStar_ST.read c)
in (x, _129_238)))))

let ind_discriminator_body = (fun env discName constrName -> (let mlid = (fresh "_discr_")
in (let _63_767 = (let _129_245 = (FStar_Absyn_Util.fv constrName)
in (FStar_Extraction_ML_Env.lookup_fv env _129_245))
in (match (_63_767) with
| (_63_765, ts) -> begin
(let arg_pat = (match ((Prims.snd ts)) with
| FStar_Extraction_ML_Syntax.MLTY_Fun (_63_769) -> begin
(FStar_Extraction_ML_Syntax.MLP_Wild)::[]
end
| _63_772 -> begin
[]
end)
in (let rid = constrName
in (let discrBody = (let _129_253 = (let _129_252 = (let _129_251 = (let _129_250 = (let _129_249 = (let _129_248 = (let _129_247 = (let _129_246 = (FStar_Extraction_ML_Syntax.mlpath_of_lident rid)
in (_129_246, arg_pat))
in FStar_Extraction_ML_Syntax.MLP_CTor (_129_247))
in (_129_248, None, FStar_Extraction_ML_Syntax.MLE_Const (FStar_Extraction_ML_Syntax.MLC_Bool (true))))
in (_129_249)::((FStar_Extraction_ML_Syntax.MLP_Wild, None, FStar_Extraction_ML_Syntax.MLE_Const (FStar_Extraction_ML_Syntax.MLC_Bool (false))))::[])
in (FStar_Extraction_ML_Syntax.MLE_Name (([], (FStar_Extraction_ML_Syntax.idsym mlid))), _129_250))
in FStar_Extraction_ML_Syntax.MLE_Match (_129_251))
in (((mlid, None))::[], _129_252))
in FStar_Extraction_ML_Syntax.MLE_Fun (_129_253))
in FStar_Extraction_ML_Syntax.MLM_Let ((false, ({FStar_Extraction_ML_Syntax.mllb_name = (FStar_Extraction_ML_Env.convIdent discName.FStar_Absyn_Syntax.ident); FStar_Extraction_ML_Syntax.mllb_tysc = None; FStar_Extraction_ML_Syntax.mllb_add_unit = false; FStar_Extraction_ML_Syntax.mllb_def = discrBody})::[])))))
end))))

let dummyPatIdent = (fun n -> (let _129_257 = (let _129_256 = (FStar_Util.string_of_int n)
in (Prims.strcat "dummyPat" _129_256))
in (_129_257, 0)))

let dummyPatIdents = (fun n -> (let _129_260 = (FStar_Extraction_ML_ExtractTyp.firstNNats n)
in (FStar_List.map dummyPatIdent _129_260)))



