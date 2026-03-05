program dumb_calculator;

{$H+}{$J-}

uses
getopts, SysUtils;

var 
operant_1 : Double;
operant_2 : Double;
options : array of TOption = (
    (Name: 'add';
    has_arg:  0;
    flag: nil;
    value: 'a')
    );
c : char = #0;
option_index : LongInt;
math_operation: function(op1, op2 : Double) : Double;

procedure wrong_arguments_number();
begin
    writeln('needs exactly 2 numbers.');
    writeln('Try again.');
    ExitCode := 1;
end;

function addition(op1, op2 : Double) : Double;
begin
    addition := op1 + op2
end;

begin
    repeat
        c := getlongopts('a',@options[0],option_index);
        case c of
            'a': math_operation := @addition;
            '?': writeln('Error with option: ', optopt);
        end;
    until c = endofoptions;

    if optind <= paramcount then
    begin
        {Check if there are exacly 2 parameters}
        if paramcount - optind + 1 <> 2 then
        begin
            wrong_arguments_number()
        end;

        operant_1 := StrToFloat(paramstr(optind));
        inc(optind);
        operant_2 := StrToFloat(paramstr(optind));

        writeln('The result is : ', math_operation(operant_1, operant_2));
        ExitCode := 0;
    end
    else
    begin
        wrong_arguments_number()
    end
end.
