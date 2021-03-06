
open Prims
# 27 "FStar.Syntax.Util.fst"
let handle_err : Prims.bool  ->  Prims.exn  ->  Prims.unit = (fun warning e -> (match (e) with
| FStar_Syntax_Syntax.Error (msg, r) -> begin
(let _127_6 = (let _127_5 = (FStar_Range.string_of_range r)
in (FStar_Util.format3 "%s : %s\n%s\n" _127_5 (if warning then begin
"Warning"
end else begin
"Error"
end) msg))
in (FStar_Util.print_string _127_6))
end
| FStar_Util.NYI (s) -> begin
(let _127_7 = (FStar_Util.format1 "Feature not yet implemented: %s" s)
in (FStar_Util.print_string _127_7))
end
| FStar_Syntax_Syntax.Err (s) -> begin
(let _127_8 = (FStar_Util.format1 "Error: %s" s)
in (FStar_Util.print_string _127_8))
end
| _38_23 -> begin
(Prims.raise e)
end))

# 37 "FStar.Syntax.Util.fst"
let handleable : Prims.exn  ->  Prims.bool = (fun _38_1 -> (match (_38_1) with
| (FStar_Syntax_Syntax.Error (_)) | (FStar_Util.NYI (_)) | (FStar_Syntax_Syntax.Err (_)) -> begin
true
end
| _38_35 -> begin
false
end))

# 43 "FStar.Syntax.Util.fst"
let mk_discriminator : FStar_Ident.lident  ->  FStar_Ident.lident = (fun lid -> (FStar_Ident.lid_of_ids (FStar_List.append lid.FStar_Ident.ns (((FStar_Ident.mk_ident ((Prims.strcat "is_" lid.FStar_Ident.ident.FStar_Ident.idText), lid.FStar_Ident.ident.FStar_Ident.idRange)))::[]))))

# 51 "FStar.Syntax.Util.fst"
let is_name : FStar_Ident.lident  ->  Prims.bool = (fun lid -> (
# 54 "FStar.Syntax.Util.fst"
let c = (FStar_Util.char_at lid.FStar_Ident.ident.FStar_Ident.idText 0)
in (FStar_Util.is_upper c)))

# 55 "FStar.Syntax.Util.fst"
let arg_of_non_null_binder = (fun _38_41 -> (match (_38_41) with
| (b, imp) -> begin
(let _127_16 = (FStar_Syntax_Syntax.bv_to_name b)
in (_127_16, imp))
end))

# 57 "FStar.Syntax.Util.fst"
let args_of_non_null_binders : FStar_Syntax_Syntax.binders  ->  (FStar_Syntax_Syntax.term * FStar_Syntax_Syntax.arg_qualifier Prims.option) Prims.list = (fun binders -> (FStar_All.pipe_right binders (FStar_List.collect (fun b -> if (FStar_Syntax_Syntax.is_null_binder b) then begin
[]
end else begin
(let _127_20 = (arg_of_non_null_binder b)
in (_127_20)::[])
end))))

# 62 "FStar.Syntax.Util.fst"
let args_of_binders : FStar_Syntax_Syntax.binders  ->  ((FStar_Syntax_Syntax.bv * FStar_Syntax_Syntax.arg_qualifier Prims.option) Prims.list * (FStar_Syntax_Syntax.term * FStar_Syntax_Syntax.arg_qualifier Prims.option) Prims.list) = (fun binders -> (let _127_27 = (FStar_All.pipe_right binders (FStar_List.map (fun b -> if (FStar_Syntax_Syntax.is_null_binder b) then begin
(
# 67 "FStar.Syntax.Util.fst"
let b = (let _127_24 = (FStar_Syntax_Syntax.new_bv None (Prims.fst b).FStar_Syntax_Syntax.sort)
in (_127_24, (Prims.snd b)))
in (let _127_25 = (arg_of_non_null_binder b)
in (b, _127_25)))
end else begin
(let _127_26 = (arg_of_non_null_binder b)
in (b, _127_26))
end)))
in (FStar_All.pipe_right _127_27 FStar_List.unzip)))

# 69 "FStar.Syntax.Util.fst"
let name_binders : FStar_Syntax_Syntax.binder Prims.list  ->  (FStar_Syntax_Syntax.bv * FStar_Syntax_Syntax.arg_qualifier Prims.option) Prims.list = (fun binders -> (FStar_All.pipe_right binders (FStar_List.mapi (fun i b -> if (FStar_Syntax_Syntax.is_null_binder b) then begin
(
# 74 "FStar.Syntax.Util.fst"
let _38_52 = b
in (match (_38_52) with
| (a, imp) -> begin
(
# 75 "FStar.Syntax.Util.fst"
let b = (let _127_33 = (let _127_32 = (FStar_Util.string_of_int i)
in (Prims.strcat "_" _127_32))
in (FStar_Ident.id_of_text _127_33))
in (
# 76 "FStar.Syntax.Util.fst"
let b = {FStar_Syntax_Syntax.ppname = b; FStar_Syntax_Syntax.index = 0; FStar_Syntax_Syntax.sort = a.FStar_Syntax_Syntax.sort}
in (b, imp)))
end))
end else begin
b
end))))

# 78 "FStar.Syntax.Util.fst"
let name_function_binders = (fun t -> (match (t.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_arrow (binders, comp) -> begin
(let _127_37 = (let _127_36 = (let _127_35 = (name_binders binders)
in (_127_35, comp))
in FStar_Syntax_Syntax.Tm_arrow (_127_36))
in (FStar_Syntax_Syntax.mk _127_37 None t.FStar_Syntax_Syntax.pos))
end
| _38_61 -> begin
t
end))

# 82 "FStar.Syntax.Util.fst"
let null_binders_of_tks : (FStar_Syntax_Syntax.typ * FStar_Syntax_Syntax.aqual) Prims.list  ->  (FStar_Syntax_Syntax.bv * FStar_Syntax_Syntax.aqual) Prims.list = (fun tks -> (FStar_All.pipe_right tks (FStar_List.map (fun _38_65 -> (match (_38_65) with
| (t, imp) -> begin
(let _127_42 = (let _127_41 = (FStar_Syntax_Syntax.null_binder t)
in (FStar_All.pipe_left Prims.fst _127_41))
in (_127_42, imp))
end)))))

# 85 "FStar.Syntax.Util.fst"
let binders_of_tks : (FStar_Syntax_Syntax.typ * FStar_Syntax_Syntax.aqual) Prims.list  ->  (FStar_Syntax_Syntax.bv * FStar_Syntax_Syntax.aqual) Prims.list = (fun tks -> (FStar_All.pipe_right tks (FStar_List.map (fun _38_69 -> (match (_38_69) with
| (t, imp) -> begin
(let _127_46 = (FStar_Syntax_Syntax.new_bv (Some (t.FStar_Syntax_Syntax.pos)) t)
in (_127_46, imp))
end)))))

# 88 "FStar.Syntax.Util.fst"
let binders_of_freevars : FStar_Syntax_Syntax.bv FStar_Util.set  ->  FStar_Syntax_Syntax.binder Prims.list = (fun fvs -> (let _127_49 = (FStar_Util.set_elements fvs)
in (FStar_All.pipe_right _127_49 (FStar_List.map FStar_Syntax_Syntax.mk_binder))))

# 90 "FStar.Syntax.Util.fst"
let mk_subst = (fun s -> (s)::[])

# 92 "FStar.Syntax.Util.fst"
let subst_of_list : FStar_Syntax_Syntax.binders  ->  FStar_Syntax_Syntax.args  ->  FStar_Syntax_Syntax.subst_t = (fun formals actuals -> if ((FStar_List.length formals) = (FStar_List.length actuals)) then begin
(FStar_List.fold_right2 (fun f a out -> (FStar_Syntax_Syntax.NT (((Prims.fst f), (Prims.fst a))))::out) formals actuals [])
end else begin
(FStar_All.failwith "Ill-formed substitution")
end)

# 97 "FStar.Syntax.Util.fst"
let rename_binders : FStar_Syntax_Syntax.binders  ->  FStar_Syntax_Syntax.binders  ->  FStar_Syntax_Syntax.subst_t = (fun replace_xs with_ys -> if ((FStar_List.length replace_xs) = (FStar_List.length with_ys)) then begin
(FStar_List.map2 (fun _38_82 _38_86 -> (match ((_38_82, _38_86)) with
| ((x, _38_81), (y, _38_85)) -> begin
(let _127_65 = (let _127_64 = (FStar_Syntax_Syntax.bv_to_name y)
in (x, _127_64))
in FStar_Syntax_Syntax.NT (_127_65))
end)) replace_xs with_ys)
end else begin
(FStar_All.failwith "Ill-formed substitution")
end)

# 104 "FStar.Syntax.Util.fst"
let rec unmeta : FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.term = (fun e -> (
# 107 "FStar.Syntax.Util.fst"
let e = (FStar_Syntax_Subst.compress e)
in (match (e.FStar_Syntax_Syntax.n) with
| (FStar_Syntax_Syntax.Tm_meta (e, _)) | (FStar_Syntax_Syntax.Tm_ascribed (e, _, _)) -> begin
(unmeta e)
end
| _38_101 -> begin
e
end)))

# 111 "FStar.Syntax.Util.fst"
let rec univ_kernel : FStar_Syntax_Syntax.universe  ->  (FStar_Syntax_Syntax.universe * Prims.int) = (fun u -> (match (u) with
| (FStar_Syntax_Syntax.U_unknown) | (FStar_Syntax_Syntax.U_name (_)) | (FStar_Syntax_Syntax.U_unif (_)) | (FStar_Syntax_Syntax.U_zero) -> begin
(u, 0)
end
| FStar_Syntax_Syntax.U_succ (u) -> begin
(
# 124 "FStar.Syntax.Util.fst"
let _38_115 = (univ_kernel u)
in (match (_38_115) with
| (k, n) -> begin
(k, (n + 1))
end))
end
| (FStar_Syntax_Syntax.U_max (_)) | (FStar_Syntax_Syntax.U_bvar (_)) -> begin
(FStar_All.failwith "Imposible")
end))

# 126 "FStar.Syntax.Util.fst"
let constant_univ_as_nat : FStar_Syntax_Syntax.universe  ->  Prims.int = (fun u -> (let _127_72 = (univ_kernel u)
in (Prims.snd _127_72)))

# 130 "FStar.Syntax.Util.fst"
let rec compare_univs : FStar_Syntax_Syntax.universe  ->  FStar_Syntax_Syntax.universe  ->  Prims.int = (fun u1 u2 -> (match ((u1, u2)) with
| ((FStar_Syntax_Syntax.U_bvar (_), _)) | ((_, FStar_Syntax_Syntax.U_bvar (_))) -> begin
(FStar_All.failwith "Impossible: compare_univs")
end
| (FStar_Syntax_Syntax.U_unknown, FStar_Syntax_Syntax.U_unknown) -> begin
0
end
| (FStar_Syntax_Syntax.U_unknown, _38_142) -> begin
(- (1))
end
| (_38_145, FStar_Syntax_Syntax.U_unknown) -> begin
1
end
| (FStar_Syntax_Syntax.U_zero, FStar_Syntax_Syntax.U_zero) -> begin
0
end
| (FStar_Syntax_Syntax.U_zero, _38_153) -> begin
(- (1))
end
| (_38_156, FStar_Syntax_Syntax.U_zero) -> begin
1
end
| (FStar_Syntax_Syntax.U_name (u1), FStar_Syntax_Syntax.U_name (u2)) -> begin
(FStar_String.compare u1.FStar_Ident.idText u2.FStar_Ident.idText)
end
| (FStar_Syntax_Syntax.U_name (_38_165), FStar_Syntax_Syntax.U_unif (_38_168)) -> begin
(- (1))
end
| (FStar_Syntax_Syntax.U_unif (_38_172), FStar_Syntax_Syntax.U_name (_38_175)) -> begin
1
end
| (FStar_Syntax_Syntax.U_unif (u1), FStar_Syntax_Syntax.U_unif (u2)) -> begin
((FStar_Unionfind.uvar_id u1) - (FStar_Unionfind.uvar_id u2))
end
| (FStar_Syntax_Syntax.U_max (us1), FStar_Syntax_Syntax.U_max (us2)) -> begin
(
# 157 "FStar.Syntax.Util.fst"
let n1 = (FStar_List.length us1)
in (
# 158 "FStar.Syntax.Util.fst"
let n2 = (FStar_List.length us2)
in if (n1 <> n2) then begin
(n1 - n2)
end else begin
(
# 161 "FStar.Syntax.Util.fst"
let copt = (let _127_78 = (FStar_List.zip us1 us2)
in (FStar_Util.find_map _127_78 (fun _38_192 -> (match (_38_192) with
| (u1, u2) -> begin
(
# 162 "FStar.Syntax.Util.fst"
let c = (compare_univs u1 u2)
in if (c <> 0) then begin
Some (c)
end else begin
None
end)
end))))
in (match (copt) with
| None -> begin
0
end
| Some (c) -> begin
c
end))
end))
end
| (FStar_Syntax_Syntax.U_max (_38_199), _38_202) -> begin
(- (1))
end
| (_38_205, FStar_Syntax_Syntax.U_max (_38_207)) -> begin
1
end
| _38_211 -> begin
(
# 175 "FStar.Syntax.Util.fst"
let _38_214 = (univ_kernel u1)
in (match (_38_214) with
| (k1, n1) -> begin
(
# 176 "FStar.Syntax.Util.fst"
let _38_217 = (univ_kernel u2)
in (match (_38_217) with
| (k2, n2) -> begin
(
# 177 "FStar.Syntax.Util.fst"
let r = (compare_univs k1 k2)
in if (r = 0) then begin
(n1 - n2)
end else begin
r
end)
end))
end))
end))

# 180 "FStar.Syntax.Util.fst"
let eq_univs : FStar_Syntax_Syntax.universe  ->  FStar_Syntax_Syntax.universe  ->  Prims.bool = (fun u1 u2 -> ((compare_univs u1 u2) = 0))

# 182 "FStar.Syntax.Util.fst"
let ml_comp : FStar_Syntax_Syntax.typ  ->  FStar_Range.range  ->  FStar_Syntax_Syntax.comp = (fun t r -> (let _127_88 = (let _127_87 = (FStar_Ident.set_lid_range FStar_Syntax_Const.effect_ML_lid r)
in {FStar_Syntax_Syntax.effect_name = _127_87; FStar_Syntax_Syntax.result_typ = t; FStar_Syntax_Syntax.effect_args = []; FStar_Syntax_Syntax.flags = (FStar_Syntax_Syntax.MLEFFECT)::[]})
in (FStar_Syntax_Syntax.mk_Comp _127_88)))

# 192 "FStar.Syntax.Util.fst"
let comp_set_flags : FStar_Syntax_Syntax.comp  ->  FStar_Syntax_Syntax.cflags Prims.list  ->  FStar_Syntax_Syntax.comp = (fun c f -> (match (c.FStar_Syntax_Syntax.n) with
| (FStar_Syntax_Syntax.Total (_)) | (FStar_Syntax_Syntax.GTotal (_)) -> begin
c
end
| FStar_Syntax_Syntax.Comp (ct) -> begin
(
# 207 "FStar.Syntax.Util.fst"
let _38_233 = c
in {FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Comp ((
# 207 "FStar.Syntax.Util.fst"
let _38_235 = ct
in {FStar_Syntax_Syntax.effect_name = _38_235.FStar_Syntax_Syntax.effect_name; FStar_Syntax_Syntax.result_typ = _38_235.FStar_Syntax_Syntax.result_typ; FStar_Syntax_Syntax.effect_args = _38_235.FStar_Syntax_Syntax.effect_args; FStar_Syntax_Syntax.flags = f})); FStar_Syntax_Syntax.tk = _38_233.FStar_Syntax_Syntax.tk; FStar_Syntax_Syntax.pos = _38_233.FStar_Syntax_Syntax.pos; FStar_Syntax_Syntax.vars = _38_233.FStar_Syntax_Syntax.vars})
end))

# 207 "FStar.Syntax.Util.fst"
let comp_flags = (fun c -> (match (c.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Total (_38_239) -> begin
(FStar_Syntax_Syntax.TOTAL)::[]
end
| FStar_Syntax_Syntax.GTotal (_38_242) -> begin
(FStar_Syntax_Syntax.SOMETRIVIAL)::[]
end
| FStar_Syntax_Syntax.Comp (ct) -> begin
ct.FStar_Syntax_Syntax.flags
end))

# 212 "FStar.Syntax.Util.fst"
let comp_effect_name = (fun c -> (match (c.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Comp (c) -> begin
c.FStar_Syntax_Syntax.effect_name
end
| FStar_Syntax_Syntax.Total (_38_250) -> begin
FStar_Syntax_Const.effect_Tot_lid
end
| FStar_Syntax_Syntax.GTotal (_38_253) -> begin
FStar_Syntax_Const.effect_GTot_lid
end))

# 217 "FStar.Syntax.Util.fst"
let comp_to_comp_typ : FStar_Syntax_Syntax.comp  ->  FStar_Syntax_Syntax.comp_typ = (fun c -> (match (c.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Comp (c) -> begin
c
end
| FStar_Syntax_Syntax.Total (t) -> begin
{FStar_Syntax_Syntax.effect_name = FStar_Syntax_Const.effect_Tot_lid; FStar_Syntax_Syntax.result_typ = t; FStar_Syntax_Syntax.effect_args = []; FStar_Syntax_Syntax.flags = (FStar_Syntax_Syntax.TOTAL)::[]}
end
| FStar_Syntax_Syntax.GTotal (t) -> begin
{FStar_Syntax_Syntax.effect_name = FStar_Syntax_Const.effect_GTot_lid; FStar_Syntax_Syntax.result_typ = t; FStar_Syntax_Syntax.effect_args = []; FStar_Syntax_Syntax.flags = (FStar_Syntax_Syntax.SOMETRIVIAL)::[]}
end))

# 223 "FStar.Syntax.Util.fst"
let is_total_comp = (fun c -> (FStar_All.pipe_right (comp_flags c) (FStar_Util.for_some (fun _38_2 -> (match (_38_2) with
| (FStar_Syntax_Syntax.TOTAL) | (FStar_Syntax_Syntax.RETURN) -> begin
true
end
| _38_267 -> begin
false
end)))))

# 226 "FStar.Syntax.Util.fst"
let is_total_lcomp : FStar_Syntax_Syntax.lcomp  ->  Prims.bool = (fun c -> ((FStar_Ident.lid_equals c.FStar_Syntax_Syntax.eff_name FStar_Syntax_Const.effect_Tot_lid) || (FStar_All.pipe_right c.FStar_Syntax_Syntax.cflags (FStar_Util.for_some (fun _38_3 -> (match (_38_3) with
| (FStar_Syntax_Syntax.TOTAL) | (FStar_Syntax_Syntax.RETURN) -> begin
true
end
| _38_273 -> begin
false
end))))))

# 228 "FStar.Syntax.Util.fst"
let is_tot_or_gtot_lcomp : FStar_Syntax_Syntax.lcomp  ->  Prims.bool = (fun c -> (((FStar_Ident.lid_equals c.FStar_Syntax_Syntax.eff_name FStar_Syntax_Const.effect_Tot_lid) || (FStar_Ident.lid_equals c.FStar_Syntax_Syntax.eff_name FStar_Syntax_Const.effect_GTot_lid)) || (FStar_All.pipe_right c.FStar_Syntax_Syntax.cflags (FStar_Util.for_some (fun _38_4 -> (match (_38_4) with
| (FStar_Syntax_Syntax.TOTAL) | (FStar_Syntax_Syntax.RETURN) -> begin
true
end
| _38_279 -> begin
false
end))))))

# 232 "FStar.Syntax.Util.fst"
let is_partial_return = (fun c -> (FStar_All.pipe_right (comp_flags c) (FStar_Util.for_some (fun _38_5 -> (match (_38_5) with
| (FStar_Syntax_Syntax.RETURN) | (FStar_Syntax_Syntax.PARTIAL_RETURN) -> begin
true
end
| _38_285 -> begin
false
end)))))

# 234 "FStar.Syntax.Util.fst"
let is_lcomp_partial_return : FStar_Syntax_Syntax.lcomp  ->  Prims.bool = (fun c -> (FStar_All.pipe_right c.FStar_Syntax_Syntax.cflags (FStar_Util.for_some (fun _38_6 -> (match (_38_6) with
| (FStar_Syntax_Syntax.RETURN) | (FStar_Syntax_Syntax.PARTIAL_RETURN) -> begin
true
end
| _38_291 -> begin
false
end)))))

# 236 "FStar.Syntax.Util.fst"
let is_tot_or_gtot_comp = (fun c -> ((is_total_comp c) || (FStar_Ident.lid_equals FStar_Syntax_Const.effect_GTot_lid (comp_effect_name c))))

# 240 "FStar.Syntax.Util.fst"
let is_pure_comp = (fun c -> (match (c.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Total (_38_295) -> begin
true
end
| FStar_Syntax_Syntax.GTotal (_38_298) -> begin
false
end
| FStar_Syntax_Syntax.Comp (ct) -> begin
((((is_total_comp c) || (FStar_Ident.lid_equals ct.FStar_Syntax_Syntax.effect_name FStar_Syntax_Const.effect_PURE_lid)) || (FStar_Ident.lid_equals ct.FStar_Syntax_Syntax.effect_name FStar_Syntax_Const.effect_Pure_lid)) || (FStar_All.pipe_right ct.FStar_Syntax_Syntax.flags (FStar_Util.for_some (fun _38_7 -> (match (_38_7) with
| FStar_Syntax_Syntax.LEMMA -> begin
true
end
| _38_305 -> begin
false
end)))))
end))

# 248 "FStar.Syntax.Util.fst"
let is_ghost_effect : FStar_Ident.lident  ->  Prims.bool = (fun l -> (((FStar_Ident.lid_equals FStar_Syntax_Const.effect_GTot_lid l) || (FStar_Ident.lid_equals FStar_Syntax_Const.effect_GHOST_lid l)) || (FStar_Ident.lid_equals FStar_Syntax_Const.effect_Ghost_lid l)))

# 253 "FStar.Syntax.Util.fst"
let is_pure_or_ghost_comp = (fun c -> ((is_pure_comp c) || (is_ghost_effect (comp_effect_name c))))

# 255 "FStar.Syntax.Util.fst"
let is_pure_lcomp : FStar_Syntax_Syntax.lcomp  ->  Prims.bool = (fun lc -> ((((is_total_lcomp lc) || (FStar_Ident.lid_equals lc.FStar_Syntax_Syntax.eff_name FStar_Syntax_Const.effect_PURE_lid)) || (FStar_Ident.lid_equals lc.FStar_Syntax_Syntax.eff_name FStar_Syntax_Const.effect_Pure_lid)) || (FStar_All.pipe_right lc.FStar_Syntax_Syntax.cflags (FStar_Util.for_some (fun _38_8 -> (match (_38_8) with
| FStar_Syntax_Syntax.LEMMA -> begin
true
end
| _38_312 -> begin
false
end))))))

# 261 "FStar.Syntax.Util.fst"
let is_pure_or_ghost_lcomp : FStar_Syntax_Syntax.lcomp  ->  Prims.bool = (fun lc -> ((is_pure_lcomp lc) || (is_ghost_effect lc.FStar_Syntax_Syntax.eff_name)))

# 264 "FStar.Syntax.Util.fst"
let is_pure_or_ghost_function : FStar_Syntax_Syntax.term  ->  Prims.bool = (fun t -> (match ((let _127_123 = (FStar_Syntax_Subst.compress t)
in _127_123.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_arrow (_38_316, c) -> begin
(is_pure_or_ghost_comp c)
end
| _38_321 -> begin
true
end))

# 268 "FStar.Syntax.Util.fst"
let is_lemma : FStar_Syntax_Syntax.term  ->  Prims.bool = (fun t -> (match ((let _127_126 = (FStar_Syntax_Subst.compress t)
in _127_126.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_arrow (_38_324, c) -> begin
(match (c.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Comp (ct) -> begin
(FStar_Ident.lid_equals ct.FStar_Syntax_Syntax.effect_name FStar_Syntax_Const.effect_Lemma_lid)
end
| _38_331 -> begin
false
end)
end
| _38_333 -> begin
false
end))

# 276 "FStar.Syntax.Util.fst"
let head_and_args : FStar_Syntax_Syntax.term  ->  (FStar_Syntax_Syntax.term * FStar_Syntax_Syntax.args) = (fun t -> (
# 280 "FStar.Syntax.Util.fst"
let t = (FStar_Syntax_Subst.compress t)
in (match (t.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_app (head, args) -> begin
(head, args)
end
| _38_341 -> begin
(t, [])
end)))

# 283 "FStar.Syntax.Util.fst"
let un_uinst : FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.term = (fun t -> (
# 286 "FStar.Syntax.Util.fst"
let t = (FStar_Syntax_Subst.compress t)
in (match (t.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_uinst (t, _38_346) -> begin
(FStar_Syntax_Subst.compress t)
end
| _38_350 -> begin
t
end)))

# 289 "FStar.Syntax.Util.fst"
let is_smt_lemma : FStar_Syntax_Syntax.term  ->  Prims.bool = (fun t -> (match ((let _127_133 = (FStar_Syntax_Subst.compress t)
in _127_133.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_arrow (_38_353, c) -> begin
(match (c.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Comp (ct) when (FStar_Ident.lid_equals ct.FStar_Syntax_Syntax.effect_name FStar_Syntax_Const.effect_Lemma_lid) -> begin
(match (ct.FStar_Syntax_Syntax.effect_args) with
| _req::_ens::(pats, _38_363)::_38_360 -> begin
(
# 297 "FStar.Syntax.Util.fst"
let pats' = (unmeta pats)
in (
# 298 "FStar.Syntax.Util.fst"
let _38_374 = (head_and_args pats')
in (match (_38_374) with
| (head, _38_373) -> begin
(match ((let _127_134 = (un_uinst head)
in _127_134.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_fvar (fv) -> begin
(FStar_Syntax_Syntax.fv_eq_lid fv FStar_Syntax_Const.cons_lid)
end
| _38_378 -> begin
false
end)
end)))
end
| _38_380 -> begin
false
end)
end
| _38_382 -> begin
false
end)
end
| _38_384 -> begin
false
end))

# 307 "FStar.Syntax.Util.fst"
let is_ml_comp = (fun c -> (match (c.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Comp (c) -> begin
((FStar_Ident.lid_equals c.FStar_Syntax_Syntax.effect_name FStar_Syntax_Const.effect_ML_lid) || (FStar_All.pipe_right c.FStar_Syntax_Syntax.flags (FStar_Util.for_some (fun _38_9 -> (match (_38_9) with
| FStar_Syntax_Syntax.MLEFFECT -> begin
true
end
| _38_391 -> begin
false
end)))))
end
| _38_393 -> begin
false
end))

# 313 "FStar.Syntax.Util.fst"
let comp_result = (fun c -> (match (c.FStar_Syntax_Syntax.n) with
| (FStar_Syntax_Syntax.Total (t)) | (FStar_Syntax_Syntax.GTotal (t)) -> begin
t
end
| FStar_Syntax_Syntax.Comp (ct) -> begin
ct.FStar_Syntax_Syntax.result_typ
end))

# 318 "FStar.Syntax.Util.fst"
let set_result_typ = (fun c t -> (match (c.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Total (_38_403) -> begin
(FStar_Syntax_Syntax.mk_Total t)
end
| FStar_Syntax_Syntax.GTotal (_38_406) -> begin
(FStar_Syntax_Syntax.mk_GTotal t)
end
| FStar_Syntax_Syntax.Comp (ct) -> begin
(FStar_Syntax_Syntax.mk_Comp (
# 323 "FStar.Syntax.Util.fst"
let _38_410 = ct
in {FStar_Syntax_Syntax.effect_name = _38_410.FStar_Syntax_Syntax.effect_name; FStar_Syntax_Syntax.result_typ = t; FStar_Syntax_Syntax.effect_args = _38_410.FStar_Syntax_Syntax.effect_args; FStar_Syntax_Syntax.flags = _38_410.FStar_Syntax_Syntax.flags}))
end))

# 323 "FStar.Syntax.Util.fst"
let is_trivial_wp = (fun c -> (FStar_All.pipe_right (comp_flags c) (FStar_Util.for_some (fun _38_10 -> (match (_38_10) with
| (FStar_Syntax_Syntax.TOTAL) | (FStar_Syntax_Syntax.RETURN) -> begin
true
end
| _38_417 -> begin
false
end)))))

# 326 "FStar.Syntax.Util.fst"
let primops : FStar_Ident.lident Prims.list = (FStar_Syntax_Const.op_Eq)::(FStar_Syntax_Const.op_notEq)::(FStar_Syntax_Const.op_LT)::(FStar_Syntax_Const.op_LTE)::(FStar_Syntax_Const.op_GT)::(FStar_Syntax_Const.op_GTE)::(FStar_Syntax_Const.op_Subtraction)::(FStar_Syntax_Const.op_Minus)::(FStar_Syntax_Const.op_Addition)::(FStar_Syntax_Const.op_Multiply)::(FStar_Syntax_Const.op_Division)::(FStar_Syntax_Const.op_Modulus)::(FStar_Syntax_Const.op_And)::(FStar_Syntax_Const.op_Or)::(FStar_Syntax_Const.op_Negation)::[]

# 346 "FStar.Syntax.Util.fst"
let is_primop_lid : FStar_Ident.lident  ->  Prims.bool = (fun l -> (FStar_All.pipe_right primops (FStar_Util.for_some (FStar_Ident.lid_equals l))))

# 347 "FStar.Syntax.Util.fst"
let is_primop = (fun f -> (match (f.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_fvar (fv) -> begin
(is_primop_lid fv.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v)
end
| _38_423 -> begin
false
end))

# 351 "FStar.Syntax.Util.fst"
let rec unascribe : FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.term = (fun e -> (
# 354 "FStar.Syntax.Util.fst"
let e = (FStar_Syntax_Subst.compress e)
in (match (e.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_ascribed (e, _38_428, _38_430) -> begin
(unascribe e)
end
| _38_434 -> begin
e
end)))

# 357 "FStar.Syntax.Util.fst"
let rec ascribe = (fun t k -> (match (t.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_ascribed (t', _38_439, _38_441) -> begin
(ascribe t' k)
end
| _38_445 -> begin
(FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_ascribed ((t, k, None))) None t.FStar_Syntax_Syntax.pos)
end))

# 361 "FStar.Syntax.Util.fst"
let rec unrefine : FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.term = (fun t -> (
# 364 "FStar.Syntax.Util.fst"
let t = (FStar_Syntax_Subst.compress t)
in (match (t.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_refine (x, _38_450) -> begin
(unrefine x.FStar_Syntax_Syntax.sort)
end
| FStar_Syntax_Syntax.Tm_ascribed (t, _38_455, _38_457) -> begin
(unrefine t)
end
| _38_461 -> begin
t
end)))

# 368 "FStar.Syntax.Util.fst"
let is_fun : FStar_Syntax_Syntax.term  ->  Prims.bool = (fun e -> (match ((let _127_153 = (FStar_Syntax_Subst.compress e)
in _127_153.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_abs (_38_464) -> begin
true
end
| _38_467 -> begin
false
end))

# 372 "FStar.Syntax.Util.fst"
let is_function_typ : FStar_Syntax_Syntax.term  ->  Prims.bool = (fun t -> (match ((let _127_156 = (FStar_Syntax_Subst.compress t)
in _127_156.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_arrow (_38_470) -> begin
true
end
| _38_473 -> begin
false
end))

# 376 "FStar.Syntax.Util.fst"
let rec pre_typ : FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.term = (fun t -> (
# 379 "FStar.Syntax.Util.fst"
let t = (FStar_Syntax_Subst.compress t)
in (match (t.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_refine (x, _38_478) -> begin
(pre_typ x.FStar_Syntax_Syntax.sort)
end
| FStar_Syntax_Syntax.Tm_ascribed (t, _38_483, _38_485) -> begin
(pre_typ t)
end
| _38_489 -> begin
t
end)))

# 383 "FStar.Syntax.Util.fst"
let destruct : FStar_Syntax_Syntax.term  ->  FStar_Ident.lident  ->  FStar_Syntax_Syntax.args Prims.option = (fun typ lid -> (
# 386 "FStar.Syntax.Util.fst"
let typ = (FStar_Syntax_Subst.compress typ)
in (match ((let _127_163 = (un_uinst typ)
in _127_163.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_app (head, args) -> begin
(
# 389 "FStar.Syntax.Util.fst"
let head = (un_uinst head)
in (match (head.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_fvar (tc) when (FStar_Syntax_Syntax.fv_eq_lid tc lid) -> begin
Some (args)
end
| _38_501 -> begin
None
end))
end
| FStar_Syntax_Syntax.Tm_fvar (tc) when (FStar_Syntax_Syntax.fv_eq_lid tc lid) -> begin
Some ([])
end
| _38_505 -> begin
None
end)))

# 395 "FStar.Syntax.Util.fst"
let rec lids_of_sigelt : FStar_Syntax_Syntax.sigelt  ->  FStar_Ident.lident Prims.list = (fun se -> (match (se) with
| (FStar_Syntax_Syntax.Sig_let (_, _, lids, _)) | (FStar_Syntax_Syntax.Sig_bundle (_, _, lids, _)) -> begin
lids
end
| (FStar_Syntax_Syntax.Sig_inductive_typ (lid, _, _, _, _, _, _, _)) | (FStar_Syntax_Syntax.Sig_effect_abbrev (lid, _, _, _, _, _)) | (FStar_Syntax_Syntax.Sig_datacon (lid, _, _, _, _, _, _, _)) | (FStar_Syntax_Syntax.Sig_declare_typ (lid, _, _, _, _)) | (FStar_Syntax_Syntax.Sig_assume (lid, _, _, _)) -> begin
(lid)::[]
end
| FStar_Syntax_Syntax.Sig_new_effect (n, _38_589) -> begin
(n.FStar_Syntax_Syntax.mname)::[]
end
| (FStar_Syntax_Syntax.Sig_sub_effect (_)) | (FStar_Syntax_Syntax.Sig_pragma (_)) | (FStar_Syntax_Syntax.Sig_main (_)) -> begin
[]
end))

# 408 "FStar.Syntax.Util.fst"
let lid_of_sigelt : FStar_Syntax_Syntax.sigelt  ->  FStar_Ident.lident Prims.option = (fun se -> (match ((lids_of_sigelt se)) with
| l::[] -> begin
Some (l)
end
| _38_605 -> begin
None
end))

# 412 "FStar.Syntax.Util.fst"
let range_of_sigelt : FStar_Syntax_Syntax.sigelt  ->  FStar_Range.range = (fun x -> (match (x) with
| (FStar_Syntax_Syntax.Sig_bundle (_, _, _, r)) | (FStar_Syntax_Syntax.Sig_inductive_typ (_, _, _, _, _, _, _, r)) | (FStar_Syntax_Syntax.Sig_effect_abbrev (_, _, _, _, _, r)) | (FStar_Syntax_Syntax.Sig_datacon (_, _, _, _, _, _, _, r)) | (FStar_Syntax_Syntax.Sig_declare_typ (_, _, _, _, r)) | (FStar_Syntax_Syntax.Sig_assume (_, _, _, r)) | (FStar_Syntax_Syntax.Sig_let (_, r, _, _)) | (FStar_Syntax_Syntax.Sig_main (_, r)) | (FStar_Syntax_Syntax.Sig_pragma (_, r)) | (FStar_Syntax_Syntax.Sig_new_effect (_, r)) | (FStar_Syntax_Syntax.Sig_sub_effect (_, r)) -> begin
r
end))

# 425 "FStar.Syntax.Util.fst"
let range_of_lb = (fun _38_11 -> (match (_38_11) with
| (FStar_Util.Inl (x), _38_706, _38_708) -> begin
(FStar_Syntax_Syntax.range_of_bv x)
end
| (FStar_Util.Inr (l), _38_713, _38_715) -> begin
(FStar_Ident.range_of_lid l)
end))

# 429 "FStar.Syntax.Util.fst"
let range_of_arg = (fun _38_720 -> (match (_38_720) with
| (hd, _38_719) -> begin
hd.FStar_Syntax_Syntax.pos
end))

# 431 "FStar.Syntax.Util.fst"
let range_of_args = (fun args r -> (FStar_All.pipe_right args (FStar_List.fold_left (fun r a -> (FStar_Range.union_ranges r (range_of_arg a))) r)))

# 434 "FStar.Syntax.Util.fst"
let mk_app = (fun f args -> (
# 437 "FStar.Syntax.Util.fst"
let r = (range_of_args args f.FStar_Syntax_Syntax.pos)
in (FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_app ((f, args))) None r)))

# 438 "FStar.Syntax.Util.fst"
let mk_data = (fun l args -> (match (args) with
| [] -> begin
(let _127_182 = (let _127_181 = (let _127_180 = (FStar_Syntax_Syntax.fvar l FStar_Syntax_Syntax.Delta_constant (Some (FStar_Syntax_Syntax.Data_ctor)))
in (_127_180, FStar_Syntax_Syntax.Meta_desugared (FStar_Syntax_Syntax.Data_app)))
in FStar_Syntax_Syntax.Tm_meta (_127_181))
in (FStar_Syntax_Syntax.mk _127_182 None (FStar_Ident.range_of_lid l)))
end
| _38_732 -> begin
(
# 445 "FStar.Syntax.Util.fst"
let e = (let _127_183 = (FStar_Syntax_Syntax.fvar l FStar_Syntax_Syntax.Delta_constant (Some (FStar_Syntax_Syntax.Data_ctor)))
in (mk_app _127_183 args))
in (FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_meta ((e, FStar_Syntax_Syntax.Meta_desugared (FStar_Syntax_Syntax.Data_app)))) None e.FStar_Syntax_Syntax.pos))
end))

# 446 "FStar.Syntax.Util.fst"
let mangle_field_name : FStar_Ident.ident  ->  FStar_Ident.ident = (fun x -> (FStar_Ident.mk_ident ((Prims.strcat "^fname^" x.FStar_Ident.idText), x.FStar_Ident.idRange)))

# 448 "FStar.Syntax.Util.fst"
let unmangle_field_name : FStar_Ident.ident  ->  FStar_Ident.ident = (fun x -> if (FStar_Util.starts_with x.FStar_Ident.idText "^fname^") then begin
(let _127_189 = (let _127_188 = (FStar_Util.substring_from x.FStar_Ident.idText 7)
in (_127_188, x.FStar_Ident.idRange))
in (FStar_Ident.mk_ident _127_189))
end else begin
x
end)

# 452 "FStar.Syntax.Util.fst"
let mk_field_projector_name : FStar_Ident.lident  ->  FStar_Syntax_Syntax.bv  ->  Prims.int  ->  (FStar_Ident.lident * FStar_Syntax_Syntax.bv) = (fun lid x i -> (
# 455 "FStar.Syntax.Util.fst"
let nm = if (FStar_Syntax_Syntax.is_null_bv x) then begin
(let _127_199 = (let _127_198 = (let _127_196 = (FStar_Util.string_of_int i)
in (Prims.strcat "_" _127_196))
in (let _127_197 = (FStar_Syntax_Syntax.range_of_bv x)
in (_127_198, _127_197)))
in (FStar_Ident.mk_ident _127_199))
end else begin
x.FStar_Syntax_Syntax.ppname
end
in (
# 458 "FStar.Syntax.Util.fst"
let y = (
# 458 "FStar.Syntax.Util.fst"
let _38_740 = x
in {FStar_Syntax_Syntax.ppname = nm; FStar_Syntax_Syntax.index = _38_740.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _38_740.FStar_Syntax_Syntax.sort})
in (let _127_203 = (let _127_202 = (let _127_201 = (let _127_200 = (unmangle_field_name nm)
in (_127_200)::[])
in (FStar_List.append (FStar_Ident.ids_of_lid lid) _127_201))
in (FStar_Ident.lid_of_ids _127_202))
in (_127_203, y)))))

# 459 "FStar.Syntax.Util.fst"
let set_uvar = (fun uv t -> (match ((FStar_Unionfind.find uv)) with
| FStar_Syntax_Syntax.Fixed (_38_746) -> begin
(let _127_208 = (let _127_207 = (let _127_206 = (FStar_Unionfind.uvar_id uv)
in (FStar_All.pipe_left FStar_Util.string_of_int _127_206))
in (FStar_Util.format1 "Changing a fixed uvar! ?%s\n" _127_207))
in (FStar_All.failwith _127_208))
end
| _38_749 -> begin
(FStar_Unionfind.change uv (FStar_Syntax_Syntax.Fixed (t)))
end))

# 464 "FStar.Syntax.Util.fst"
let qualifier_equal : FStar_Syntax_Syntax.qualifier  ->  FStar_Syntax_Syntax.qualifier  ->  Prims.bool = (fun q1 q2 -> (match ((q1, q2)) with
| (FStar_Syntax_Syntax.Discriminator (l1), FStar_Syntax_Syntax.Discriminator (l2)) -> begin
(FStar_Ident.lid_equals l1 l2)
end
| (FStar_Syntax_Syntax.Projector (l1a, l1b), FStar_Syntax_Syntax.Projector (l2a, l2b)) -> begin
((FStar_Ident.lid_equals l1a l2a) && (l1b.FStar_Ident.idText = l2b.FStar_Ident.idText))
end
| ((FStar_Syntax_Syntax.RecordType (f1), FStar_Syntax_Syntax.RecordType (f2))) | ((FStar_Syntax_Syntax.RecordConstructor (f1), FStar_Syntax_Syntax.RecordConstructor (f2))) -> begin
(((FStar_List.length f1) = (FStar_List.length f2)) && (FStar_List.forall2 FStar_Ident.lid_equals f1 f2))
end
| _38_775 -> begin
(q1 = q2)
end))

# 471 "FStar.Syntax.Util.fst"
let rec arrow_formals_comp : FStar_Syntax_Syntax.term  ->  ((FStar_Syntax_Syntax.bv * FStar_Syntax_Syntax.arg_qualifier Prims.option) Prims.list * FStar_Syntax_Syntax.comp) = (fun k -> (
# 478 "FStar.Syntax.Util.fst"
let k = (FStar_Syntax_Subst.compress k)
in (match (k.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_arrow (bs, c) -> begin
(
# 481 "FStar.Syntax.Util.fst"
let _38_784 = (FStar_Syntax_Subst.open_comp bs c)
in (match (_38_784) with
| (bs, c) -> begin
if (is_tot_or_gtot_comp c) then begin
(
# 483 "FStar.Syntax.Util.fst"
let _38_787 = (arrow_formals_comp (comp_result c))
in (match (_38_787) with
| (bs', k) -> begin
((FStar_List.append bs bs'), k)
end))
end else begin
(bs, c)
end
end))
end
| _38_789 -> begin
(let _127_215 = (FStar_Syntax_Syntax.mk_Total k)
in ([], _127_215))
end)))

# 486 "FStar.Syntax.Util.fst"
let rec arrow_formals : FStar_Syntax_Syntax.term  ->  ((FStar_Syntax_Syntax.bv * FStar_Syntax_Syntax.arg_qualifier Prims.option) Prims.list * FStar_Syntax_Syntax.typ) = (fun k -> (
# 489 "FStar.Syntax.Util.fst"
let _38_793 = (arrow_formals_comp k)
in (match (_38_793) with
| (bs, c) -> begin
(bs, (comp_result c))
end)))

# 490 "FStar.Syntax.Util.fst"
let rec abs_formals : FStar_Syntax_Syntax.term  ->  ((FStar_Syntax_Syntax.bv * FStar_Syntax_Syntax.arg_qualifier Prims.option) Prims.list * FStar_Syntax_Syntax.term) = (fun t -> (match ((let _127_220 = (FStar_Syntax_Subst.compress t)
in _127_220.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_abs (bs, t, _38_798) -> begin
(
# 494 "FStar.Syntax.Util.fst"
let _38_803 = (abs_formals t)
in (match (_38_803) with
| (bs', t) -> begin
(FStar_Syntax_Subst.open_term (FStar_List.append bs bs') t)
end))
end
| _38_805 -> begin
([], t)
end))

# 496 "FStar.Syntax.Util.fst"
let abs : (FStar_Syntax_Syntax.bv * FStar_Syntax_Syntax.arg_qualifier Prims.option) Prims.list  ->  FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.lcomp Prims.option  ->  FStar_Syntax_Syntax.term = (fun bs t lopt -> (match (bs) with
| [] -> begin
t
end
| _38_811 -> begin
(
# 501 "FStar.Syntax.Util.fst"
let body = (let _127_227 = (FStar_Syntax_Subst.close bs t)
in (FStar_Syntax_Subst.compress _127_227))
in (match ((body.FStar_Syntax_Syntax.n, lopt)) with
| (FStar_Syntax_Syntax.Tm_abs (bs', t, lopt'), None) -> begin
(let _127_231 = (let _127_230 = (let _127_229 = (let _127_228 = (FStar_Syntax_Subst.close_binders bs)
in (FStar_List.append _127_228 bs'))
in (_127_229, t, lopt))
in FStar_Syntax_Syntax.Tm_abs (_127_230))
in (FStar_Syntax_Syntax.mk _127_231 None t.FStar_Syntax_Syntax.pos))
end
| _38_821 -> begin
(
# 506 "FStar.Syntax.Util.fst"
let lopt = (match (lopt) with
| None -> begin
None
end
| Some (lc) -> begin
(let _127_232 = (FStar_Syntax_Subst.close_lcomp bs lc)
in Some (_127_232))
end)
in (let _127_235 = (let _127_234 = (let _127_233 = (FStar_Syntax_Subst.close_binders bs)
in (_127_233, body, lopt))
in FStar_Syntax_Syntax.Tm_abs (_127_234))
in (FStar_Syntax_Syntax.mk _127_235 None t.FStar_Syntax_Syntax.pos)))
end))
end))

# 509 "FStar.Syntax.Util.fst"
let arrow : (FStar_Syntax_Syntax.bv * FStar_Syntax_Syntax.arg_qualifier Prims.option) Prims.list  ->  (FStar_Syntax_Syntax.comp', Prims.unit) FStar_Syntax_Syntax.syntax  ->  FStar_Syntax_Syntax.typ = (fun bs c -> (match (bs) with
| [] -> begin
(comp_result c)
end
| _38_830 -> begin
(let _127_243 = (let _127_242 = (let _127_241 = (FStar_Syntax_Subst.close_binders bs)
in (let _127_240 = (FStar_Syntax_Subst.close_comp bs c)
in (_127_241, _127_240)))
in FStar_Syntax_Syntax.Tm_arrow (_127_242))
in (FStar_Syntax_Syntax.mk _127_243 None c.FStar_Syntax_Syntax.pos))
end))

# 513 "FStar.Syntax.Util.fst"
let refine : FStar_Syntax_Syntax.bv  ->  FStar_Syntax_Syntax.term  ->  (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax = (fun b t -> (let _127_255 = (let _127_251 = (let _127_250 = (let _127_249 = (let _127_248 = (FStar_Syntax_Syntax.mk_binder b)
in (_127_248)::[])
in (FStar_Syntax_Subst.close _127_249 t))
in (b, _127_250))
in FStar_Syntax_Syntax.Tm_refine (_127_251))
in (let _127_254 = (FStar_ST.read b.FStar_Syntax_Syntax.sort.FStar_Syntax_Syntax.tk)
in (let _127_253 = (let _127_252 = (FStar_Syntax_Syntax.range_of_bv b)
in (FStar_Range.union_ranges _127_252 t.FStar_Syntax_Syntax.pos))
in (FStar_Syntax_Syntax.mk _127_255 _127_254 _127_253)))))

# 514 "FStar.Syntax.Util.fst"
let branch : FStar_Syntax_Syntax.branch  ->  FStar_Syntax_Syntax.branch = (fun b -> (FStar_Syntax_Subst.close_branch b))

# 515 "FStar.Syntax.Util.fst"
let mk_letbinding : FStar_Syntax_Syntax.lbname  ->  FStar_Syntax_Syntax.univ_name Prims.list  ->  FStar_Syntax_Syntax.typ  ->  FStar_Ident.lident  ->  FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.letbinding = (fun lbname univ_vars typ eff def -> {FStar_Syntax_Syntax.lbname = lbname; FStar_Syntax_Syntax.lbunivs = univ_vars; FStar_Syntax_Syntax.lbtyp = typ; FStar_Syntax_Syntax.lbeff = eff; FStar_Syntax_Syntax.lbdef = def})

# 522 "FStar.Syntax.Util.fst"
let close_univs_and_mk_letbinding : FStar_Syntax_Syntax.fv Prims.list Prims.option  ->  FStar_Syntax_Syntax.lbname  ->  FStar_Syntax_Syntax.univ_name Prims.list  ->  FStar_Syntax_Syntax.term  ->  FStar_Ident.lident  ->  FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.letbinding = (fun recs lbname univ_vars typ eff def -> (
# 525 "FStar.Syntax.Util.fst"
let def = (match ((recs, univ_vars)) with
| ((None, _)) | ((_, [])) -> begin
def
end
| (Some (fvs), _38_856) -> begin
(
# 529 "FStar.Syntax.Util.fst"
let universes = (FStar_All.pipe_right univ_vars (FStar_List.map (fun _127_280 -> FStar_Syntax_Syntax.U_name (_127_280))))
in (
# 530 "FStar.Syntax.Util.fst"
let inst = (FStar_All.pipe_right fvs (FStar_List.map (fun fv -> (fv.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v, universes))))
in (FStar_Syntax_InstFV.instantiate inst def)))
end)
in (
# 532 "FStar.Syntax.Util.fst"
let typ = (FStar_Syntax_Subst.close_univ_vars univ_vars typ)
in (
# 533 "FStar.Syntax.Util.fst"
let def = (FStar_Syntax_Subst.close_univ_vars univ_vars def)
in (mk_letbinding lbname univ_vars typ eff def)))))

# 534 "FStar.Syntax.Util.fst"
let open_univ_vars_binders_and_comp : FStar_Syntax_Syntax.univ_names  ->  (FStar_Syntax_Syntax.bv * FStar_Syntax_Syntax.arg_qualifier Prims.option) Prims.list  ->  FStar_Syntax_Syntax.comp  ->  (FStar_Syntax_Syntax.univ_names * (FStar_Syntax_Syntax.bv * FStar_Syntax_Syntax.arg_qualifier Prims.option) Prims.list * FStar_Syntax_Syntax.comp) = (fun uvs binders c -> (match (binders) with
| [] -> begin
(
# 539 "FStar.Syntax.Util.fst"
let _38_870 = (FStar_Syntax_Subst.open_univ_vars_comp uvs c)
in (match (_38_870) with
| (uvs, c) -> begin
(uvs, [], c)
end))
end
| _38_872 -> begin
(
# 542 "FStar.Syntax.Util.fst"
let t' = (arrow binders c)
in (
# 543 "FStar.Syntax.Util.fst"
let _38_876 = (FStar_Syntax_Subst.open_univ_vars uvs t')
in (match (_38_876) with
| (uvs, t') -> begin
(match ((let _127_288 = (FStar_Syntax_Subst.compress t')
in _127_288.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_arrow (binders, c) -> begin
(uvs, binders, c)
end
| _38_882 -> begin
(FStar_All.failwith "Impossible")
end)
end)))
end))

# 546 "FStar.Syntax.Util.fst"
let is_tuple_constructor : FStar_Syntax_Syntax.typ  ->  Prims.bool = (fun t -> (match (t.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_fvar (fv) -> begin
(FStar_Util.starts_with fv.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v.FStar_Ident.str "Prims.tuple")
end
| _38_887 -> begin
false
end))

# 553 "FStar.Syntax.Util.fst"
let mk_tuple_lid : Prims.int  ->  FStar_Range.range  ->  FStar_Ident.lident = (fun n r -> (
# 556 "FStar.Syntax.Util.fst"
let t = (let _127_295 = (FStar_Util.string_of_int n)
in (FStar_Util.format1 "tuple%s" _127_295))
in (let _127_296 = (FStar_Syntax_Const.pconst t)
in (FStar_Ident.set_lid_range _127_296 r))))

# 557 "FStar.Syntax.Util.fst"
let mk_tuple_data_lid : Prims.int  ->  FStar_Range.range  ->  FStar_Ident.lident = (fun n r -> (
# 560 "FStar.Syntax.Util.fst"
let t = (let _127_301 = (FStar_Util.string_of_int n)
in (FStar_Util.format1 "Mktuple%s" _127_301))
in (let _127_302 = (FStar_Syntax_Const.pconst t)
in (FStar_Ident.set_lid_range _127_302 r))))

# 561 "FStar.Syntax.Util.fst"
let is_tuple_data_lid : FStar_Ident.lident  ->  Prims.int  ->  Prims.bool = (fun f n -> (let _127_307 = (mk_tuple_data_lid n FStar_Range.dummyRange)
in (FStar_Ident.lid_equals f _127_307)))

# 564 "FStar.Syntax.Util.fst"
let is_dtuple_constructor : FStar_Syntax_Syntax.typ  ->  Prims.bool = (fun t -> (match (t.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_fvar (fv) -> begin
(FStar_Util.starts_with fv.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v.FStar_Ident.str "Prims.dtuple")
end
| _38_900 -> begin
false
end))

# 568 "FStar.Syntax.Util.fst"
let mk_dtuple_lid : Prims.int  ->  FStar_Range.range  ->  FStar_Ident.lident = (fun n r -> (
# 571 "FStar.Syntax.Util.fst"
let t = (let _127_314 = (FStar_Util.string_of_int n)
in (FStar_Util.format1 "dtuple%s" _127_314))
in (let _127_315 = (FStar_Syntax_Const.pconst t)
in (FStar_Ident.set_lid_range _127_315 r))))

# 572 "FStar.Syntax.Util.fst"
let mk_dtuple_data_lid : Prims.int  ->  FStar_Range.range  ->  FStar_Ident.lident = (fun n r -> (
# 575 "FStar.Syntax.Util.fst"
let t = (let _127_320 = (FStar_Util.string_of_int n)
in (FStar_Util.format1 "Mkdtuple%s" _127_320))
in (let _127_321 = (FStar_Syntax_Const.pconst t)
in (FStar_Ident.set_lid_range _127_321 r))))

# 576 "FStar.Syntax.Util.fst"
let is_lid_equality : FStar_Ident.lident  ->  Prims.bool = (fun x -> (FStar_Ident.lid_equals x FStar_Syntax_Const.eq2_lid))

# 578 "FStar.Syntax.Util.fst"
let is_forall : FStar_Ident.lident  ->  Prims.bool = (fun lid -> (FStar_Ident.lid_equals lid FStar_Syntax_Const.forall_lid))

# 580 "FStar.Syntax.Util.fst"
let is_exists : FStar_Ident.lident  ->  Prims.bool = (fun lid -> (FStar_Ident.lid_equals lid FStar_Syntax_Const.exists_lid))

# 581 "FStar.Syntax.Util.fst"
let is_qlid : FStar_Ident.lident  ->  Prims.bool = (fun lid -> ((is_forall lid) || (is_exists lid)))

# 582 "FStar.Syntax.Util.fst"
let is_equality = (fun x -> (is_lid_equality x.FStar_Syntax_Syntax.v))

# 583 "FStar.Syntax.Util.fst"
let lid_is_connective : FStar_Ident.lident  ->  Prims.bool = (
# 586 "FStar.Syntax.Util.fst"
let lst = (FStar_Syntax_Const.and_lid)::(FStar_Syntax_Const.or_lid)::(FStar_Syntax_Const.not_lid)::(FStar_Syntax_Const.iff_lid)::(FStar_Syntax_Const.imp_lid)::[]
in (fun lid -> (FStar_Util.for_some (FStar_Ident.lid_equals lid) lst)))

# 588 "FStar.Syntax.Util.fst"
let is_constructor : FStar_Syntax_Syntax.term  ->  FStar_Ident.lident  ->  Prims.bool = (fun t lid -> (match ((let _127_337 = (pre_typ t)
in _127_337.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_fvar (tc) -> begin
(FStar_Ident.lid_equals tc.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v lid)
end
| _38_919 -> begin
false
end))

# 593 "FStar.Syntax.Util.fst"
let rec is_constructed_typ : FStar_Syntax_Syntax.term  ->  FStar_Ident.lident  ->  Prims.bool = (fun t lid -> (match ((let _127_342 = (pre_typ t)
in _127_342.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_fvar (_38_923) -> begin
(is_constructor t lid)
end
| FStar_Syntax_Syntax.Tm_app (t, _38_927) -> begin
(is_constructed_typ t lid)
end
| _38_931 -> begin
false
end))

# 598 "FStar.Syntax.Util.fst"
let rec get_tycon : FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.term Prims.option = (fun t -> (
# 601 "FStar.Syntax.Util.fst"
let t = (pre_typ t)
in (match (t.FStar_Syntax_Syntax.n) with
| (FStar_Syntax_Syntax.Tm_bvar (_)) | (FStar_Syntax_Syntax.Tm_name (_)) | (FStar_Syntax_Syntax.Tm_fvar (_)) -> begin
Some (t)
end
| FStar_Syntax_Syntax.Tm_app (t, _38_945) -> begin
(get_tycon t)
end
| _38_949 -> begin
None
end)))

# 607 "FStar.Syntax.Util.fst"
let sortByFieldName = (fun fn_a_l -> (FStar_All.pipe_right fn_a_l (FStar_List.sortWith (fun _38_955 _38_959 -> (match ((_38_955, _38_959)) with
| ((fn1, _38_954), (fn2, _38_958)) -> begin
(FStar_String.compare (FStar_Ident.text_of_lid fn1) (FStar_Ident.text_of_lid fn2))
end)))))

# 614 "FStar.Syntax.Util.fst"
let is_interpreted : FStar_Ident.lident  ->  Prims.bool = (fun l -> (
# 617 "FStar.Syntax.Util.fst"
let theory_syms = (FStar_Syntax_Const.op_Eq)::(FStar_Syntax_Const.op_notEq)::(FStar_Syntax_Const.op_LT)::(FStar_Syntax_Const.op_LTE)::(FStar_Syntax_Const.op_GT)::(FStar_Syntax_Const.op_GTE)::(FStar_Syntax_Const.op_Subtraction)::(FStar_Syntax_Const.op_Minus)::(FStar_Syntax_Const.op_Addition)::(FStar_Syntax_Const.op_Multiply)::(FStar_Syntax_Const.op_Division)::(FStar_Syntax_Const.op_Modulus)::(FStar_Syntax_Const.op_And)::(FStar_Syntax_Const.op_Or)::(FStar_Syntax_Const.op_Negation)::[]
in (FStar_Util.for_some (FStar_Ident.lid_equals l) theory_syms)))

# 633 "FStar.Syntax.Util.fst"
let ktype : (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax = (FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_type (FStar_Syntax_Syntax.U_unknown)) None FStar_Range.dummyRange)

# 639 "FStar.Syntax.Util.fst"
let ktype0 : (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax = (FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_type (FStar_Syntax_Syntax.U_zero)) None FStar_Range.dummyRange)

# 640 "FStar.Syntax.Util.fst"
let type_u : Prims.unit  ->  (FStar_Syntax_Syntax.typ * FStar_Syntax_Syntax.universe) = (fun _38_962 -> (match (()) with
| () -> begin
(
# 644 "FStar.Syntax.Util.fst"
let u = (let _127_353 = (FStar_Unionfind.fresh None)
in (FStar_All.pipe_left (fun _127_352 -> FStar_Syntax_Syntax.U_unif (_127_352)) _127_353))
in (let _127_354 = (FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_type (u)) None FStar_Range.dummyRange)
in (_127_354, u)))
end))

# 645 "FStar.Syntax.Util.fst"
let kt_kt : (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax = (FStar_Syntax_Const.kunary ktype0 ktype0)

# 647 "FStar.Syntax.Util.fst"
let kt_kt_kt : (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax = (FStar_Syntax_Const.kbin ktype0 ktype0 ktype0)

# 648 "FStar.Syntax.Util.fst"
let fvar_const : FStar_Ident.lident  ->  FStar_Syntax_Syntax.term = (fun l -> (FStar_Syntax_Syntax.fvar l FStar_Syntax_Syntax.Delta_constant None))

# 650 "FStar.Syntax.Util.fst"
let tand : FStar_Syntax_Syntax.term = (fvar_const FStar_Syntax_Const.and_lid)

# 651 "FStar.Syntax.Util.fst"
let tor : FStar_Syntax_Syntax.term = (fvar_const FStar_Syntax_Const.or_lid)

# 652 "FStar.Syntax.Util.fst"
let timp : FStar_Syntax_Syntax.term = (fvar_const FStar_Syntax_Const.imp_lid)

# 653 "FStar.Syntax.Util.fst"
let tiff : FStar_Syntax_Syntax.term = (fvar_const FStar_Syntax_Const.iff_lid)

# 654 "FStar.Syntax.Util.fst"
let t_bool : FStar_Syntax_Syntax.term = (fvar_const FStar_Syntax_Const.bool_lid)

# 655 "FStar.Syntax.Util.fst"
let t_false : FStar_Syntax_Syntax.term = (fvar_const FStar_Syntax_Const.false_lid)

# 656 "FStar.Syntax.Util.fst"
let t_true : FStar_Syntax_Syntax.term = (fvar_const FStar_Syntax_Const.true_lid)

# 657 "FStar.Syntax.Util.fst"
let b2t_v : FStar_Syntax_Syntax.term = (fvar_const FStar_Syntax_Const.b2t_lid)

# 658 "FStar.Syntax.Util.fst"
let t_not : FStar_Syntax_Syntax.term = (fvar_const FStar_Syntax_Const.not_lid)

# 659 "FStar.Syntax.Util.fst"
let mk_conj_opt : FStar_Syntax_Syntax.term Prims.option  ->  FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.term Prims.option = (fun phi1 phi2 -> (match (phi1) with
| None -> begin
Some (phi2)
end
| Some (phi1) -> begin
(let _127_368 = (let _127_367 = (let _127_365 = (let _127_364 = (let _127_363 = (FStar_Syntax_Syntax.as_arg phi1)
in (let _127_362 = (let _127_361 = (FStar_Syntax_Syntax.as_arg phi2)
in (_127_361)::[])
in (_127_363)::_127_362))
in (tand, _127_364))
in FStar_Syntax_Syntax.Tm_app (_127_365))
in (let _127_366 = (FStar_Range.union_ranges phi1.FStar_Syntax_Syntax.pos phi2.FStar_Syntax_Syntax.pos)
in (FStar_Syntax_Syntax.mk _127_367 None _127_366)))
in Some (_127_368))
end))

# 663 "FStar.Syntax.Util.fst"
let mk_binop = (fun op_t phi1 phi2 -> (let _127_378 = (let _127_376 = (let _127_375 = (let _127_374 = (FStar_Syntax_Syntax.as_arg phi1)
in (let _127_373 = (let _127_372 = (FStar_Syntax_Syntax.as_arg phi2)
in (_127_372)::[])
in (_127_374)::_127_373))
in (op_t, _127_375))
in FStar_Syntax_Syntax.Tm_app (_127_376))
in (let _127_377 = (FStar_Range.union_ranges phi1.FStar_Syntax_Syntax.pos phi2.FStar_Syntax_Syntax.pos)
in (FStar_Syntax_Syntax.mk _127_378 None _127_377))))

# 664 "FStar.Syntax.Util.fst"
let mk_neg = (fun phi -> (let _127_383 = (let _127_382 = (let _127_381 = (let _127_380 = (FStar_Syntax_Syntax.as_arg phi)
in (_127_380)::[])
in (t_not, _127_381))
in FStar_Syntax_Syntax.Tm_app (_127_382))
in (FStar_Syntax_Syntax.mk _127_383 None phi.FStar_Syntax_Syntax.pos)))

# 665 "FStar.Syntax.Util.fst"
let mk_conj = (fun phi1 phi2 -> (mk_binop tand phi1 phi2))

# 666 "FStar.Syntax.Util.fst"
let mk_conj_l : FStar_Syntax_Syntax.term Prims.list  ->  FStar_Syntax_Syntax.term = (fun phi -> (match (phi) with
| [] -> begin
(FStar_Syntax_Syntax.fvar FStar_Syntax_Const.true_lid FStar_Syntax_Syntax.Delta_constant None)
end
| hd::tl -> begin
(FStar_List.fold_right mk_conj tl hd)
end))

# 669 "FStar.Syntax.Util.fst"
let mk_disj = (fun phi1 phi2 -> (mk_binop tor phi1 phi2))

# 670 "FStar.Syntax.Util.fst"
let mk_disj_l : FStar_Syntax_Syntax.term Prims.list  ->  FStar_Syntax_Syntax.term = (fun phi -> (match (phi) with
| [] -> begin
t_false
end
| hd::tl -> begin
(FStar_List.fold_right mk_disj tl hd)
end))

# 673 "FStar.Syntax.Util.fst"
let mk_imp : FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.term = (fun phi1 phi2 -> (match ((let _127_396 = (FStar_Syntax_Subst.compress phi1)
in _127_396.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_fvar (tc) when (FStar_Syntax_Syntax.fv_eq_lid tc FStar_Syntax_Const.false_lid) -> begin
t_true
end
| FStar_Syntax_Syntax.Tm_fvar (tc) when (FStar_Syntax_Syntax.fv_eq_lid tc FStar_Syntax_Const.true_lid) -> begin
phi2
end
| _38_995 -> begin
(match ((let _127_397 = (FStar_Syntax_Subst.compress phi2)
in _127_397.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_fvar (tc) when ((FStar_Syntax_Syntax.fv_eq_lid tc FStar_Syntax_Const.true_lid) || (FStar_Syntax_Syntax.fv_eq_lid tc FStar_Syntax_Const.false_lid)) -> begin
phi2
end
| _38_999 -> begin
(mk_binop timp phi1 phi2)
end)
end))

# 683 "FStar.Syntax.Util.fst"
let mk_iff = (fun phi1 phi2 -> (mk_binop tiff phi1 phi2))

# 684 "FStar.Syntax.Util.fst"
let b2t = (fun e -> (let _127_404 = (let _127_403 = (let _127_402 = (let _127_401 = (FStar_Syntax_Syntax.as_arg e)
in (_127_401)::[])
in (b2t_v, _127_402))
in FStar_Syntax_Syntax.Tm_app (_127_403))
in (FStar_Syntax_Syntax.mk _127_404 None e.FStar_Syntax_Syntax.pos)))

# 685 "FStar.Syntax.Util.fst"
let teq : FStar_Syntax_Syntax.term = (fvar_const FStar_Syntax_Const.eq2_lid)

# 687 "FStar.Syntax.Util.fst"
let mk_eq = (fun t1 t2 e1 e2 -> (let _127_415 = (let _127_413 = (let _127_412 = (let _127_411 = (FStar_Syntax_Syntax.as_arg e1)
in (let _127_410 = (let _127_409 = (FStar_Syntax_Syntax.as_arg e2)
in (_127_409)::[])
in (_127_411)::_127_410))
in (teq, _127_412))
in FStar_Syntax_Syntax.Tm_app (_127_413))
in (let _127_414 = (FStar_Range.union_ranges e1.FStar_Syntax_Syntax.pos e2.FStar_Syntax_Syntax.pos)
in (FStar_Syntax_Syntax.mk _127_415 None _127_414))))

# 689 "FStar.Syntax.Util.fst"
let mk_has_type = (fun t x t' -> (
# 692 "FStar.Syntax.Util.fst"
let t_has_type = (fvar_const FStar_Syntax_Const.has_type_lid)
in (
# 693 "FStar.Syntax.Util.fst"
let t_has_type = (FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_uinst ((t_has_type, (FStar_Syntax_Syntax.U_zero)::(FStar_Syntax_Syntax.U_zero)::[]))) None FStar_Range.dummyRange)
in (let _127_426 = (let _127_425 = (let _127_424 = (let _127_423 = (FStar_Syntax_Syntax.iarg t)
in (let _127_422 = (let _127_421 = (FStar_Syntax_Syntax.as_arg x)
in (let _127_420 = (let _127_419 = (FStar_Syntax_Syntax.as_arg t')
in (_127_419)::[])
in (_127_421)::_127_420))
in (_127_423)::_127_422))
in (t_has_type, _127_424))
in FStar_Syntax_Syntax.Tm_app (_127_425))
in (FStar_Syntax_Syntax.mk _127_426 None FStar_Range.dummyRange)))))

# 694 "FStar.Syntax.Util.fst"
let lex_t : FStar_Syntax_Syntax.term = (fvar_const FStar_Syntax_Const.lex_t_lid)

# 696 "FStar.Syntax.Util.fst"
let lex_top : FStar_Syntax_Syntax.term = (FStar_Syntax_Syntax.fvar FStar_Syntax_Const.lextop_lid FStar_Syntax_Syntax.Delta_constant (Some (FStar_Syntax_Syntax.Data_ctor)))

# 697 "FStar.Syntax.Util.fst"
let lex_pair : FStar_Syntax_Syntax.term = (FStar_Syntax_Syntax.fvar FStar_Syntax_Const.lexcons_lid FStar_Syntax_Syntax.Delta_constant (Some (FStar_Syntax_Syntax.Data_ctor)))

# 698 "FStar.Syntax.Util.fst"
let tforall : FStar_Syntax_Syntax.term = (FStar_Syntax_Syntax.fvar FStar_Syntax_Const.forall_lid (FStar_Syntax_Syntax.Delta_unfoldable (1)) None)

# 699 "FStar.Syntax.Util.fst"
let lcomp_of_comp : FStar_Syntax_Syntax.comp  ->  FStar_Syntax_Syntax.lcomp = (fun c0 -> (
# 702 "FStar.Syntax.Util.fst"
let c = (comp_to_comp_typ c0)
in {FStar_Syntax_Syntax.eff_name = c.FStar_Syntax_Syntax.effect_name; FStar_Syntax_Syntax.res_typ = c.FStar_Syntax_Syntax.result_typ; FStar_Syntax_Syntax.cflags = c.FStar_Syntax_Syntax.flags; FStar_Syntax_Syntax.comp = (fun _38_1014 -> (match (()) with
| () -> begin
c0
end))}))

# 706 "FStar.Syntax.Util.fst"
let mk_forall : FStar_Syntax_Syntax.bv  ->  FStar_Syntax_Syntax.typ  ->  (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax = (fun x body -> (let _127_443 = (let _127_442 = (let _127_441 = (let _127_440 = (let _127_439 = (let _127_438 = (let _127_434 = (FStar_Syntax_Syntax.mk_binder x)
in (_127_434)::[])
in (let _127_437 = (let _127_436 = (let _127_435 = (FStar_Syntax_Syntax.mk_Total ktype0)
in (FStar_All.pipe_left lcomp_of_comp _127_435))
in Some (_127_436))
in (abs _127_438 body _127_437)))
in (FStar_Syntax_Syntax.as_arg _127_439))
in (_127_440)::[])
in (tforall, _127_441))
in FStar_Syntax_Syntax.Tm_app (_127_442))
in (FStar_Syntax_Syntax.mk _127_443 None FStar_Range.dummyRange)))

# 709 "FStar.Syntax.Util.fst"
let rec close_forall : FStar_Syntax_Syntax.binder Prims.list  ->  FStar_Syntax_Syntax.typ  ->  FStar_Syntax_Syntax.typ = (fun bs f -> (FStar_List.fold_right (fun b f -> if (FStar_Syntax_Syntax.is_null_binder b) then begin
f
end else begin
(mk_forall (Prims.fst b) f)
end) bs f))

# 712 "FStar.Syntax.Util.fst"
let rec is_wild_pat = (fun p -> (match (p.FStar_Syntax_Syntax.v) with
| FStar_Syntax_Syntax.Pat_wild (_38_1023) -> begin
true
end
| _38_1026 -> begin
false
end))

# 717 "FStar.Syntax.Util.fst"
let if_then_else = (fun b t1 t2 -> (
# 720 "FStar.Syntax.Util.fst"
let then_branch = (let _127_454 = (FStar_Syntax_Syntax.withinfo (FStar_Syntax_Syntax.Pat_constant (FStar_Const.Const_bool (true))) FStar_Syntax_Syntax.tun.FStar_Syntax_Syntax.n t1.FStar_Syntax_Syntax.pos)
in (_127_454, None, t1))
in (
# 721 "FStar.Syntax.Util.fst"
let else_branch = (let _127_455 = (FStar_Syntax_Syntax.withinfo (FStar_Syntax_Syntax.Pat_constant (FStar_Const.Const_bool (false))) FStar_Syntax_Syntax.tun.FStar_Syntax_Syntax.n t2.FStar_Syntax_Syntax.pos)
in (_127_455, None, t2))
in (let _127_457 = (let _127_456 = (FStar_Range.union_ranges t1.FStar_Syntax_Syntax.pos t2.FStar_Syntax_Syntax.pos)
in (FStar_Range.union_ranges b.FStar_Syntax_Syntax.pos _127_456))
in (FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_match ((b, (then_branch)::(else_branch)::[]))) None _127_457)))))

# 722 "FStar.Syntax.Util.fst"
type qpats =
FStar_Syntax_Syntax.args Prims.list

# 727 "FStar.Syntax.Util.fst"
type connective =
| QAll of (FStar_Syntax_Syntax.binders * qpats * FStar_Syntax_Syntax.typ)
| QEx of (FStar_Syntax_Syntax.binders * qpats * FStar_Syntax_Syntax.typ)
| BaseConn of (FStar_Ident.lident * FStar_Syntax_Syntax.args)

# 729 "FStar.Syntax.Util.fst"
let is_QAll = (fun _discr_ -> (match (_discr_) with
| QAll (_) -> begin
true
end
| _ -> begin
false
end))

# 730 "FStar.Syntax.Util.fst"
let is_QEx = (fun _discr_ -> (match (_discr_) with
| QEx (_) -> begin
true
end
| _ -> begin
false
end))

# 731 "FStar.Syntax.Util.fst"
let is_BaseConn = (fun _discr_ -> (match (_discr_) with
| BaseConn (_) -> begin
true
end
| _ -> begin
false
end))

# 729 "FStar.Syntax.Util.fst"
let ___QAll____0 = (fun projectee -> (match (projectee) with
| QAll (_38_1034) -> begin
_38_1034
end))

# 730 "FStar.Syntax.Util.fst"
let ___QEx____0 = (fun projectee -> (match (projectee) with
| QEx (_38_1037) -> begin
_38_1037
end))

# 731 "FStar.Syntax.Util.fst"
let ___BaseConn____0 = (fun projectee -> (match (projectee) with
| BaseConn (_38_1040) -> begin
_38_1040
end))

# 731 "FStar.Syntax.Util.fst"
let destruct_typ_as_formula : FStar_Syntax_Syntax.term  ->  connective Prims.option = (fun f -> (
# 734 "FStar.Syntax.Util.fst"
let destruct_base_conn = (fun f -> (
# 735 "FStar.Syntax.Util.fst"
let connectives = ((FStar_Syntax_Const.true_lid, 0))::((FStar_Syntax_Const.false_lid, 0))::((FStar_Syntax_Const.and_lid, 2))::((FStar_Syntax_Const.or_lid, 2))::((FStar_Syntax_Const.imp_lid, 2))::((FStar_Syntax_Const.iff_lid, 2))::((FStar_Syntax_Const.ite_lid, 3))::((FStar_Syntax_Const.not_lid, 1))::((FStar_Syntax_Const.eq2_lid, 4))::((FStar_Syntax_Const.eq2_lid, 2))::[]
in (
# 746 "FStar.Syntax.Util.fst"
let rec aux = (fun f _38_1049 -> (match (_38_1049) with
| (lid, arity) -> begin
(
# 747 "FStar.Syntax.Util.fst"
let _38_1052 = (head_and_args f)
in (match (_38_1052) with
| (t, args) -> begin
(
# 748 "FStar.Syntax.Util.fst"
let t = (un_uinst t)
in if ((is_constructor t lid) && ((FStar_List.length args) = arity)) then begin
Some (BaseConn ((lid, args)))
end else begin
None
end)
end))
end))
in (FStar_Util.find_map connectives (aux f)))))
in (
# 755 "FStar.Syntax.Util.fst"
let patterns = (fun t -> (
# 756 "FStar.Syntax.Util.fst"
let t = (FStar_Syntax_Subst.compress t)
in (match (t.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_meta (t, FStar_Syntax_Syntax.Meta_pattern (pats)) -> begin
(let _127_510 = (FStar_Syntax_Subst.compress t)
in (pats, _127_510))
end
| _38_1063 -> begin
(let _127_511 = (FStar_Syntax_Subst.compress t)
in ([], _127_511))
end)))
in (
# 761 "FStar.Syntax.Util.fst"
let destruct_q_conn = (fun t -> (
# 762 "FStar.Syntax.Util.fst"
let is_q = (fun fa fv -> if fa then begin
(is_forall fv.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v)
end else begin
(is_exists fv.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v)
end)
in (
# 763 "FStar.Syntax.Util.fst"
let flat = (fun t -> (
# 764 "FStar.Syntax.Util.fst"
let _38_1073 = (head_and_args t)
in (match (_38_1073) with
| (t, args) -> begin
(let _127_523 = (un_uinst t)
in (let _127_522 = (FStar_All.pipe_right args (FStar_List.map (fun _38_1076 -> (match (_38_1076) with
| (t, imp) -> begin
(let _127_521 = (unascribe t)
in (_127_521, imp))
end))))
in (_127_523, _127_522)))
end)))
in (
# 766 "FStar.Syntax.Util.fst"
let rec aux = (fun qopt out t -> (match ((let _127_530 = (flat t)
in (qopt, _127_530))) with
| ((Some (fa), ({FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_fvar (tc); FStar_Syntax_Syntax.tk = _; FStar_Syntax_Syntax.pos = _; FStar_Syntax_Syntax.vars = _}, ({FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_abs (b::[], t2, _); FStar_Syntax_Syntax.tk = _; FStar_Syntax_Syntax.pos = _; FStar_Syntax_Syntax.vars = _}, _)::[]))) | ((Some (fa), ({FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_fvar (tc); FStar_Syntax_Syntax.tk = _; FStar_Syntax_Syntax.pos = _; FStar_Syntax_Syntax.vars = _}, _::({FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_abs (b::[], t2, _); FStar_Syntax_Syntax.tk = _; FStar_Syntax_Syntax.pos = _; FStar_Syntax_Syntax.vars = _}, _)::[]))) when (is_q fa tc) -> begin
(aux qopt ((b)::out) t2)
end
| ((None, ({FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_fvar (tc); FStar_Syntax_Syntax.tk = _; FStar_Syntax_Syntax.pos = _; FStar_Syntax_Syntax.vars = _}, ({FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_abs (b::[], t2, _); FStar_Syntax_Syntax.tk = _; FStar_Syntax_Syntax.pos = _; FStar_Syntax_Syntax.vars = _}, _)::[]))) | ((None, ({FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_fvar (tc); FStar_Syntax_Syntax.tk = _; FStar_Syntax_Syntax.pos = _; FStar_Syntax_Syntax.vars = _}, _::({FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_abs (b::[], t2, _); FStar_Syntax_Syntax.tk = _; FStar_Syntax_Syntax.pos = _; FStar_Syntax_Syntax.vars = _}, _)::[]))) when (is_qlid tc.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v) -> begin
(aux (Some ((is_forall tc.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v))) ((b)::out) t2)
end
| (Some (b), _38_1203) -> begin
(
# 778 "FStar.Syntax.Util.fst"
let bs = (FStar_List.rev out)
in (
# 779 "FStar.Syntax.Util.fst"
let _38_1208 = (FStar_Syntax_Subst.open_term bs t)
in (match (_38_1208) with
| (bs, t) -> begin
(
# 780 "FStar.Syntax.Util.fst"
let _38_1211 = (patterns t)
in (match (_38_1211) with
| (pats, body) -> begin
if b then begin
Some (QAll ((bs, pats, body)))
end else begin
Some (QEx ((bs, pats, body)))
end
end))
end)))
end
| _38_1213 -> begin
None
end))
in (aux None [] t)))))
in (
# 788 "FStar.Syntax.Util.fst"
let phi = (FStar_Syntax_Subst.compress f)
in (match ((destruct_base_conn phi)) with
| Some (b) -> begin
Some (b)
end
| None -> begin
(destruct_q_conn phi)
end))))))




