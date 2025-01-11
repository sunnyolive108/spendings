type spending = {
  category : string;
  amount : float;
  date : string;
}

let create_spending category amount date = { category; amount; date }