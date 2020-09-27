let re_float = Str.regexp ".+\\..+[Ff]"
let re_double = Str.regexp ".+\\..+"
let re_unsigned = Str.regexp ".+[Uu].*"
let re_long = Str.regexp ".+[Ll].*"

let type_of_lit0 fallback_type = function
  | LNum str ->
      if Str.string_match re_float str 0 then
        Float
      else if Str.string_match re_double str 0 then
        Double
      else if Str.string_match re_unsigned str 0 then
        if Str.string_match re_long str 0 then
          ULong
        else
          let l = (String.length str)-1 in
          let s = String.make l '0' in
          let n =
            int_of_string (
                let buf = HGBytes.of_string s in
                (HGBytes.blit (HGBytes.of_string str) 0 buf 0 l);
                HGBytes.to_string buf
              )
          in
          if n >=0 && n <256 then
            UChar
          else if n >= 256 && n < 65536 then
            UShort
          else
            fallback_type

      else if Str.string_match re_long str 0 then
        Long

      else
        let sn = int_of_string str in
        if -32768 <= sn  && sn < 32768 then
          Short
        else
          fallback_type

  | LChar str -> Char

  | LString str -> Char

  | _ -> Unknown


let rec get_constant_typ lit { et = (_, _, fallback_type); _ } =
  match lit with
  | LSym k ->
      let t =
        match Symtbl.find_opt k (HGOption.some_of !symtbl) with
        | None -> Unknown
        | Some lit0 -> type_of_lit0 fallback_type lit0
      in
      t

  | Lit l0 ->
      type_of_lit0 fallback_type l0
