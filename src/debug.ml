(**
   Debugging and pretty-printing functions
*)


let pp_coefs fmt (constant, coefs, vars) =
  assert (Array.length coefs = Array.length vars) ;
  Format.fprintf fmt "%a*%s@ " Q.pp_print coefs.(0) (Smt.ZZ.T.to_string vars.(0)) ;
  for i = 1 to Array.length vars - 1 do
    Format.fprintf fmt "+ %a*%s@ " Q.pp_print coefs.(i) (Smt.ZZ.T.to_string vars.(i)) ;
  done ;
  begin match constant with
    | Some c -> Format.fprintf fmt "+ %a" Q.pp_print c ;
    | None -> ()
  end


let rec pp_list ?(pp_sep = Format.pp_print_space) pp_v ppf = function
  | [] -> ()
  | [v] -> pp_v ppf v
  | v :: vs ->
      pp_v ppf v;
      pp_sep ppf ();
      pp_list ~pp_sep pp_v ppf vs

let pp_array ?(pp_sep = Format.pp_print_space) pp_elem fmt a =
  let n = Array.length a in
  if n = 0 then ()
  else begin
    pp_elem fmt a.(0);
    if n > 1 then
      for i = 1 to n - 1 do
        pp_sep fmt ();
        pp_elem fmt a.(i);
      done
  end

let pp_matrix pp_v fmt m =
  Format.pp_open_vbox fmt 0 ;
  Array.iter (fun a ->
    Format.pp_print_string fmt "|" ;
    pp_array ~pp_sep:(fun fmt () -> Format.fprintf fmt "; ")  pp_v fmt a ;
    Format.fprintf fmt " |@," ;
  ) m ;
  Format.pp_close_box fmt ()


let pp_qarray fmt t =
  Format.fprintf fmt "@[[ %a ]@]"
    (pp_array ~pp_sep:(fun fmt () -> Format.fprintf fmt "; ") Q.pp_print) t
let pp_zarray fmt t =
  Format.fprintf fmt "@[[ %a ]@]"
    (pp_array ~pp_sep:(fun fmt () -> Format.fprintf fmt "; ") Z.pp_print) t

let pp_qmatrix m = pp_matrix Q.pp_print m
let pp_zmatrix m = pp_matrix Z.pp_print m