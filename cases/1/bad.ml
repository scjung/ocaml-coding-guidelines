let rec get_constant_typ lit e =
  match lit with
  | LSym k ->
      begin
        match Symtbl.find_opt k (HGOption.some_of !symtbl) with
        | None ->Unknown
        | Some lit0 -> get_constant_typ (Lit lit0) e
      end
  | Lit lit0 ->
      begin
        match lit0 with
        | LNum str    ->
            let flt = Str.string_match (Str.regexp ".+\\..+[Ff]") str 0 in
            let dbl = Str.string_match (Str.regexp ".+\\..+") str 0 in
            let usgn = Str.string_match (Str.regexp ".+[Uu].*") str 0 in
            let long = Str.string_match (Str.regexp ".+[Ll].*") str 0 in
            if flt then Float
            else if dbl then Double
            else if usgn then
              if long then ULong
              else begin
                let l = (String.length str)-1 in
                let s = String.make l '0' in
                let n =
                  int_of_string (
                      let buf = HGBytes.of_string s in
                      (HGBytes.blit (HGBytes.of_string str) 0 buf 0 l);
                      HGBytes.to_string buf
                    )
                in
                if n >=0 && n <256 then UChar
                else if n >= 256 && n < 65536 then UShort
                else let (_,_,t) = e.et in t
              end
            else if long then Long
            else begin
              let sn = int_of_string str in
              if -32768 <= sn  && sn < 32768 then Short
              (* if -32768 <= sn  && sn < -128 then Short *)
              (* else if -128 <= sn && sn < 128 then SChar (* 왜 여기가 SChar? *) *)
              (* else if 128 <= sn && sn < 32768 then Short *)
              else
                let (_,_,t) = e.et in t
            end
        | LChar str   -> Char
        | LString str -> Char
        | _           -> Unknown
      end
