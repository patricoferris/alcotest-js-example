module Alcotest = Alcotest_js
module Jv = Search.Jv

let documents =
  let docs =
    [
      Jv.obj
        [|
          ("title", Jv.of_string "Hello"); ("language", Jv.of_string "English");
        |];
      Jv.obj
        [|
          ("title", Jv.of_string "Bonjour"); ("language", Jv.of_string "French");
        |];
      Jv.obj
        [|
          ("title", Jv.of_string "Hola"); ("language", Jv.of_string "Spanish");
        |];
    ]
  in
  Jv.of_jv_list docs

let search =
  let s = Search.v "title" in
  Search.add_index [ Search.Jv.of_string "title" ] s;
  Search.add_index [ Search.Jv.of_string "language" ] s;
  Search.add_documents documents s;
  s

let simple_test () =
  let expect = "Hello" in
  let actual = Search.search "English" search |> Jv.to_jv_list |> List.hd in
  let actual = Jv.get actual "title" |> Jv.to_string in
  Alcotest.(check string) "same string" expect actual

let spanish () =
  let expect = "Hola" in
  let actual = Search.search "Ho" search |> Jv.to_jv_list |> List.hd in
  let actual = Jv.get actual "title" |> Jv.to_string in
  Alcotest.(check string) "same string" expect actual

let fail_french () =
  let expect = "Salut" in
  let actual = Search.search "French" search |> Jv.to_jv_list |> List.hd in
  let actual = Jv.get actual "title" |> Jv.to_string in
  Alcotest.(check string) "same string" expect actual

let tests =
  Alcotest.
    [
      test_case "simple" `Quick simple_test;
      test_case "spanish" `Quick spanish;
      test_case "fail french" `Quick fail_french;
    ]

let run () = Alcotest.run "Search" [ ("common", tests) ]
