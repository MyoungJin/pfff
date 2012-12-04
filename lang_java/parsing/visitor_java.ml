(* Copyright (C) 2012 Facebook
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License
 * version 2.1 as published by the Free Software Foundation, with the
 * special exception on linking described in file license.txt.
 *
 * This library is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the file
 * license.txt for more details.
 *)

open Common

open Ocaml

open Ast_java


(* Continuation-style visitor for a subset of concepts; similar to
   visitor_php. The bulk of this file was generated with:

   ocamltarzan -choice vi ast_java.ml

   (cf. 'generated by' comment below). The main visitor hooks
   were carefully handcrafted during a coffee binge.
*)

(* hooks *)
type visitor_in = {
  kexpr:    (expr        -> unit) * visitor_out -> expr        -> unit;
  kstmt:    (stmt        -> unit) * visitor_out -> stmt        -> unit;
  ktype:    (typ         -> unit) * visitor_out -> typ         -> unit;
  kvar:     (var         -> unit) * visitor_out -> var         -> unit;
  kinit:    (init        -> unit) * visitor_out -> init        -> unit;
  kmethod:  (method_decl -> unit) * visitor_out -> method_decl -> unit;
  kfield:   (field       -> unit) * visitor_out -> field       -> unit;
  kclass:   (class_decl  -> unit) * visitor_out -> class_decl  -> unit;
  kdecl:    (decl        -> unit) * visitor_out -> decl        -> unit;
  kprogram: (program     -> unit) * visitor_out -> program     -> unit;
}
and visitor_out = any -> unit

let default_visitor = {
  kexpr    = (fun (k,_) x -> k x);
  kstmt    = (fun (k,_) x -> k x);
  ktype    = (fun (k,_) x -> k x);
  kvar     = (fun (k,_) x -> k x);
  kinit    = (fun (k,_) x -> k x);
  kmethod  = (fun (k,_) x -> k x);
  kfield   = (fun (k,_) x -> k x);
  kclass   = (fun (k,_) x -> k x);
  kdecl    = (fun (k,_) x -> k x);
  kprogram = (fun (k,_) x -> k x);
}


let (mk_visitor: visitor_in -> visitor_out) = fun vin ->

let rec v_ident _ = ()

and v_typ x =
  vin.ktype ((fun _ -> ()), all_functions) x

and v_wrap _of_a (v1, v2) =  _of_a v1; ()

and v_op = v_string

and v_modifiers _ = ()

and v_qualified_ident _ = ()

and v_type_parameter _ = ()

and v_program x =
  let k x = v_list v_decl x.decls in
  vin.kprogram (k, all_functions) x

and v_any x = match x with
  | Expr2 e   -> v_expr e
  | Stmt s    -> v_stmt s
  | Typ t     -> v_typ t
  | Var v     -> v_var v
  | Init2 i   -> v_init i
  | Method2 m -> v_method_decl m
  | Field2 f  -> v_field f
  | Class2 c  -> v_class_decl c
  | Decl d    -> v_decl d
  | Program p -> v_program p

(* generated by ocamltarzan with: camlp4o -o /tmp/yyy.ml -I pa/ pa_type_conv.cmo pa_visitor.cmo  pr_o.cmo /tmp/xxx.ml  *)

and v_list1 _of_a = v_list _of_a
and v_name v =
  v_list1
    (fun (v1, v2) ->
      let v1 = v_list v_type_argument v1 and v2 = v_ident v2 in ())
    v

and v_type_argument =
  function
  | TArgument v1 -> let v1 = v_ref_type v1 in ()
  | TQuestion v1 ->
      let v1 =
        v_option
          (fun (v1, v2) -> let v1 = v_bool v1 and v2 = v_ref_type v2 in ())
          v1
      in ()

and v_expr (x : expr) =
  let k x = match x with
    | Name v1 -> let v1 = v_name v1 in ()
    | Literal v1 -> let v1 = v_wrap v_string v1 in ()
    | ClassLiteral v1 -> let v1 = v_typ v1 in ()
    | NewClass ((v1, v2, v3)) ->
      let v1 = v_typ v1
      and v2 = v_arguments v2
      and v3 = v_option v_decls v3
      in ()
    | NewArray ((v1, v2, v3, v4)) ->
      let v1 = v_typ v1
      and v2 = v_arguments v2
      and v3 = v_int v3
      and v4 = v_option v_init v4
      in ()
    | NewQualifiedClass ((v1, v2, v3, v4)) ->
      let v1 = v_expr v1
      and v2 = v_ident v2
      and v3 = v_arguments v3
      and v4 = v_option v_decls v4
      in ()
    | Call ((v1, v2)) -> let v1 = v_expr v1 and v2 = v_arguments v2 in ()
    | Dot ((v1, v2)) -> let v1 = v_expr v1 and v2 = v_ident v2 in ()
    | ArrayAccess ((v1, v2)) -> let v1 = v_expr v1 and v2 = v_expr v2 in ()
    | Postfix ((v1, v2)) -> let v1 = v_expr v1 and v2 = v_op v2 in ()
    | Prefix ((v1, v2)) -> let v1 = v_op v1 and v2 = v_expr v2 in ()
    | Infix ((v1, v2, v3)) ->
      let v1 = v_expr v1 and v2 = v_op v2 and v3 = v_expr v3 in ()
    | Cast ((v1, v2)) -> let v1 = v_typ v1 and v2 = v_expr v2 in ()
    | InstanceOf ((v1, v2)) -> let v1 = v_expr v1 and v2 = v_ref_type v2 in ()
    | Conditional ((v1, v2, v3)) ->
      let v1 = v_expr v1 and v2 = v_expr v2 and v3 = v_expr v3 in ()
    | Assignment ((v1, v2, v3)) ->
      let v1 = v_expr v1 and v2 = v_op v2 and v3 = v_expr v3 in ()
  in
  vin.kexpr (k, all_functions) x

and v_ref_type v = v_typ v

and v_arguments v = v_list v_expr v
and v_stmt (x : stmt) =
  let k x = match x with
  | Empty -> ()
  | Block v1 -> let v1 = v_stmts v1 in ()
  | Expr v1 -> let v1 = v_expr v1 in ()
  | If ((v1, v2, v3)) ->
      let v1 = v_expr v1 and v2 = v_stmt v2 and v3 = v_stmt v3 in ()
  | Switch ((v1, v2)) ->
      let v1 = v_expr v1
      and v2 =
        v_list
          (fun (v1, v2) -> let v1 = v_cases v1 and v2 = v_stmts v2 in ()) v2
      in ()
  | While ((v1, v2)) -> let v1 = v_expr v1 and v2 = v_stmt v2 in ()
  | Do ((v1, v2)) -> let v1 = v_stmt v1 and v2 = v_expr v2 in ()
  | For ((v1, v2)) -> let v1 = v_for_control v1 and v2 = v_stmt v2 in ()
  | Break v1 -> let v1 = v_option v_ident v1 in ()
  | Continue v1 -> let v1 = v_option v_ident v1 in ()
  | Return v1 -> let v1 = v_option v_expr v1 in ()
  | Label ((v1, v2)) -> let v1 = v_ident v1 and v2 = v_stmt v2 in ()
  | Sync ((v1, v2)) -> let v1 = v_expr v1 and v2 = v_stmt v2 in ()
  | Try ((v1, v2, v3)) ->
      let v1 = v_stmt v1
      and v2 = v_catches v2
      and v3 = v_option v_stmt v3
      in ()
  | Throw v1 -> let v1 = v_expr v1 in ()
  | LocalVar v1 -> let v1 = v_var_with_init v1 in ()
  | LocalClass v1 -> let v1 = v_class_decl v1 in ()
  | Assert ((v1, v2)) -> let v1 = v_expr v1 and v2 = v_option v_expr v2 in ()
  in
  vin.kstmt (k, all_functions) x

and v_stmts v = v_list v_stmt v
and v_case = function | Case v1 -> let v1 = v_expr v1 in () | Default -> ()
and v_cases v = v_list v_case v
and v_for_control =
  function
  | ForClassic ((v1, v2, v3)) ->
      let v1 = v_for_init v1
      and v2 = v_list v_expr v2
      and v3 = v_list v_expr v3
      in ()
  | Foreach ((v1, v2)) -> let v1 = v_var v1 and v2 = v_expr v2 in ()
and v_for_init =
  function
  | ForInitVars v1 -> let v1 = v_list v_var_with_init v1 in ()
  | ForInitExprs v1 -> let v1 = v_list v_expr v1 in ()
and v_catch (v1, v2) = let v1 = v_var v1 and v2 = v_stmt v2 in ()
and v_catches v = v_list v_catch v
and v_var x =
  let k x = match x with
    | { v_name = v_v_name; v_mods = v_v_mods; v_type = v_v_type } ->
      let arg = v_ident v_v_name in
      let arg = v_modifiers v_v_mods in let arg = v_typ v_v_type in ()
  in
  vin.kvar (k, all_functions) x

and v_vars v = v_list v_var v
and v_var_with_init { f_var = v_f_var; f_init = v_f_init } =
  let arg = v_var v_f_var in let arg = v_option v_init v_f_init in ()
and v_init (x : init) =
  let k x = match x with
  | ExprInit v1 -> let v1 = v_expr v1 in ()
  | ArrayInit v1 -> let v1 = v_list v_init v1 in ()
  in
  vin.kinit (k, all_functions) x

and v_method_decl (x : method_decl) =
  let k x = match x with
      {  m_var = v_m_var;
         m_formals = v_m_formals;
         m_throws = v_m_throws;
         m_body = v_m_body
      } ->  let arg = v_var v_m_var in
            let arg = v_vars v_m_formals in
            let arg = v_list v_qualified_ident v_m_throws in
            let arg = v_stmt v_m_body in ()
  in
  vin.kmethod (k, all_functions) x

and v_field v =
  let k x = v_var_with_init x in
  vin.kfield (k, all_functions) v

and
  v_enum_decl {
                en_name = v_en_name;
                en_mods = v_en_mods;
                en_impls = v_en_impls;
                en_body = v_en_body
              } =
  let arg = v_ident v_en_name in
  let arg = v_modifiers v_en_mods in
  let arg = v_list v_ref_type v_en_impls in
  let arg =
    match v_en_body with
    | (v1, v2) ->
        let v1 = v_list v_enum_constant v1 and v2 = v_decls v2 in ()
  in ()
and v_enum_constant =
  function
  | EnumSimple v1 -> let v1 = v_ident v1 in ()
  | EnumConstructor ((v1, v2)) ->
      let v1 = v_ident v1 and v2 = v_arguments v2 in ()
  | EnumWithMethods ((v1, v2)) ->
      let v1 = v_ident v1 and v2 = v_list v_method_decl v2 in ()
and v_class_decl (x : class_decl) =
  let k x = match x with
      { cl_name = v_cl_name;
        cl_kind = v_cl_kind;
        cl_tparams = v_cl_tparams;
        cl_mods = v_cl_mods;
        cl_extends = v_cl_extends;
        cl_impls = v_cl_impls;
        cl_body = v_cl_body
      } -> let arg = v_ident v_cl_name in
           let arg = v_class_kind v_cl_kind in
           let arg = v_list v_type_parameter v_cl_tparams in
           let arg = v_modifiers v_cl_mods in
           let arg = v_option v_typ v_cl_extends in
           let arg = v_list v_ref_type v_cl_impls in let arg = v_decls v_cl_body in ()
  in
  vin.kclass (k, all_functions) x

and v_class_kind = function | ClassRegular -> () | Interface -> ()
and v_decl x =
  let k x = match x with
  | Class v1 -> let v1 = v_class_decl v1 in ()
  | Method v1 -> let v1 = v_method_decl v1 in ()
  | Field v1 -> let v1 = v_field v1 in ()
  | Enum v1 -> let v1 = v_enum_decl v1 in ()
  | Init ((v1, v2)) -> let v1 = v_bool v1 and v2 = v_stmt v2 in ()
  in
  vin.kdecl (k, all_functions) x


and v_decls v = v_list v_decl v

(* end not-really-auto generation... *)
and all_functions x = v_any x
in
  v_any
