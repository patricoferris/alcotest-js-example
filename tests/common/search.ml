open Js_of_ocaml

(* Brr-style FFI *)
module Jv = struct
  type t = Js.Unsafe.top Js.t

  let get (v : t) (s : string) : t = Js.Unsafe.get (Js.Unsafe.coerce v) s

  let set (elt : t) (s : string) (v : t) =
    Js.Unsafe.set (Js.Unsafe.coerce elt) s v

  let call (elt : t) (s : string) (args : t array) =
    Js.Unsafe.meth_call elt s args

  let find (elt : t) (s : string) : t option =
    let v = Js.Unsafe.get (Js.Unsafe.coerce elt) s in
    if v == Js.undefined || v == Js.null then None else Some v

  let global : t = Js.Unsafe.global |> Js.Unsafe.coerce

  let to_float (v : t) = Js.float_of_number (Js.Unsafe.coerce v)

  let to_int (v : t) = to_float v |> int_of_float

  let of_int i : t = Js.number_of_float (float_of_int i) |> Js.Unsafe.coerce

  let to_bool (v : t) = Js.(to_bool (Unsafe.coerce v))

  let to_string (v : t) = Js.(to_string (Unsafe.coerce v))

  let of_string s : t = Js.string s |> Js.Unsafe.coerce

  let obj = Js.Unsafe.obj

  let error_message t = Js.string_of_error (Js.Unsafe.coerce t)

  let pp ppf v = Fmt.pf ppf "%s" (to_string v)

  external equal : t -> t -> bool = "caml_js_equals"

  external new' : t -> t array -> t = "caml_js_new"

  external of_jv_list : t list -> t = "caml_list_to_js_array"

  external to_jv_list : t -> t list = "caml_list_of_js_array"
end

let js_search =
  match Jv.(find global "__JS__search") with
  | Some v -> v
  | None -> Jv.(get global "JsSearch")

let v idx =
  let s = Jv.get js_search "Search" in
  Jv.new' s [| Jv.of_string idx |]

let add_index v s = Jv.call s "addIndex" [| Jv.of_jv_list v |] |> ignore

let search s t = Jv.call t "search" [| Jv.of_string s |]

let add_documents docs t = Jv.call t "addDocuments" [| docs |] |> ignore
