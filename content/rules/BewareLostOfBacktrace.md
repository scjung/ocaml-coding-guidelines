* Language: ko 
* Keywords: array, index

# 스택 트레이스 정보가 유실되지 않도록 주의하시오.

    catch
    | e -> 
        print_endline "Error!";
        print_endline (Printexc.get_backtrace ())