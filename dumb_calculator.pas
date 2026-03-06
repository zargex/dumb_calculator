program dumb_calculator;

{$H+}{$J-}

uses
//getopts for the options
//sysutils to convert from string to number
getopts, SysUtils;

var 
// These will be the 2 numbers we want to work with
operant_1 : Single;
operant_2 : Single;

// Dynamic array of long options 
options : array of TOption = (
    (Name: 'add';   // The option will be --add
    has_arg:  0;    // 0 :it has no args, 1: it has and 2: it has optionals args
    flag: nil;      // pointer to will store the value 
    value: 'a'),    // value returned by getlongopts or set into flag
    (Name: 'sub';
    has_arg:  0;
    flag: nil;
    value: 's'),
    (Name: 'mul';
    has_arg:  0;
    flag: nil;
    value: 'm'),
    (Name: 'div';
    has_arg:  0;
    flag: nil;
    value: 'd'),
    (Name: 'help';
    has_arg:  0;
    flag: nil;
    value: 'h')
    );

// This index is used by getlongopts() to tell use the index of the option
// in the options array that was found. 
option_index : LongInt;

// just a placehold to store the value returned by getlongopts()
c : char = #0;

// This is the final operation we want to do. It can be changed by making it to
// point to another function with the same signature
math_operation: function(op1, op2 : Single) : Single = nil;

// Just a helper message
procedure wrong_arguments_number();
begin
    writeln('needs exactly 2 numbers.');
    writeln('Try again.');
    halt(1);
end;

procedure help_message();
begin
    writeln('dumb_calculator is a simple calculator');
    writeln('How to use: dump_calculator OP arg1 arg2');
    writeln('where OP is one of the following option and arg1 and arg2 are numbers');
    writeln('Options:');
    writeln('--add | -a : Addition');
    writeln('--sub | -s : Subtraction');
    writeln('--mul | -m : Multiplication');
    writeln('--div | -d : Division');
    halt(0);
end;

// Definitions of the operations
function addition(op1, op2 : Single) : Single;
begin
    addition := op1 + op2
end;

function subtraction(op1, op2 : Single) : Single;
begin
    subtraction := op1 - op2
end;

function multiplication(op1, op2 : Single) : Single;
begin
    multiplication := op1 * op2
end;

function division(op1, op2 : Single) : Single;
begin
    division := op1 / op2
end;

begin
    // loop to process all the options
    repeat
        c := getlongopts('asmdh',@options[0],option_index);
        // getlongopts returns a char representing the option it found.
        // Or '?' in case an unknown option
        case c of
            'a': math_operation := @addition;
            's': math_operation := @subtraction;
            'm': math_operation := @multiplication;
            'd': math_operation := @division;
            'h': help_message();
            '?': writeln('Error with option: ', optopt);
        end;
    until c = endofoptions;

    // After the option now the arguments
    // paramcount returns the number of arguments
    // optind is a variable set by getopts, it has the index of
    // the first argument (non-option) 
    if optind <= paramcount then
    begin
        // Check if there are exacly 2 parameters
        if paramcount - optind + 1 <> 2 then
        begin
            wrong_arguments_number()
        end;

        // Correct number of parameters
        // Proceed to convert them to numbers
        operant_1 := StrToFloat(paramstr(optind));
        inc(optind);
        operant_2 := StrToFloat(paramstr(optind));

        if math_operation = nil then
        begin
            writeln('No operation selected.');
            halt(1);
        end;

        // Print the result and finish the program
        writeln('The result is : ', math_operation(operant_1, operant_2):6:2);
        ExitCode := 0;
    end
    else
    begin
        wrong_arguments_number()
    end
end.
