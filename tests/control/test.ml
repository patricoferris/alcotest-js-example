let simple_test () = Alcotest.(check string) "same string" "hello" "bonjousr"

let tests = Alcotest.[ test_case "simple" `Quick simple_test ]

let () = Alcotest.run "Search" [ ("common", tests) ]
