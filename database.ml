open Sqlite3

let init_db () = 
  exec db "CREATE TABLE IF NOT EXISTS spendings (id INTEGER PRIMARY KEY AUTOINCREMENT, 
         category TEXT, amount REAL, date TEXT)" |> ignore

let add_spending category amount date =
  let stmt = prepare db "INSERT INTO spendings (category, amount, date) VALUES (?, ?, ?)" in 
  bind_string stmt 1 (Data.TEXT category) |> ignore;
  bind_double stmt 2 (Data.FLOAT amount) |> ignore;
  bind_string stmt 3 (Data.TEXT date) |> ignore;
  step stmt |> ignore;
  finalize stmt

let get_spendings () =
  let stmt = prepare db "SELECT * FROM spendings" in
  let rec loop acc =
    match step stmt with
    | Rc.ROW -> loop ((column stmt 0, float_of_string (column stmt 1), column stmt 2) :: acc)
    | _ -> finalize stmt; List.rev acc
  in
  loop []

let close_db () = close_db db
