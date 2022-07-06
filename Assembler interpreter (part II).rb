=begin

This is the second part of this kata series. First part is here.

We want to create an interpreter of assembler which will support the following instructions:

    mov x, y - copy y (either an integer or the value of a register) into register x.
    inc x - increase the content of register x by one.
    dec x - decrease the content of register x by one.
    add x, y - add the content of the register x with y (either an integer or the value of a register) and stores the result in x (i.e. register[x] += y).
    sub x, y - subtract y (either an integer or the value of a register) from the register x and stores the result in x (i.e. register[x] -= y).
    mul x, y - same with multiply (i.e. register[x] *= y).
    div x, y - same with integer division (i.e. register[x] /= y).
    label: - define a label position (label = identifier + ":", an identifier being a string that does not match any other command). Jump commands and call are aimed to these labels positions in the program.
    jmp lbl - jumps to the label lbl.
    cmp x, y - compares x (either an integer or the value of a register) and y (either an integer or the value of a register). The result is used in the conditional jumps (jne, je, jge, jg, jle and jl)
    jne lbl - jump to the label lbl if the values of the previous cmp command were not equal.
    je lbl - jump to the label lbl if the values of the previous cmp command were equal.
    jge lbl - jump to the label lbl if x was greater or equal than y in the previous cmp command.
    jg lbl - jump to the label lbl if x was greater than y in the previous cmp command.
    jle lbl - jump to the label lbl if x was less or equal than y in the previous cmp command.
    jl lbl - jump to the label lbl if x was less than y in the previous cmp command.
    call lbl - call to the subroutine identified by lbl. When a ret is found in a subroutine, the instruction pointer should return to the instruction next to this call command.
    ret - when a ret is found in a subroutine, the instruction pointer should return to the instruction that called the current function.
    msg 'Register: ', x - this instruction stores the output of the program. It may contain text strings (delimited by single quotes) and registers. The number of arguments isn't limited and will vary, depending on the program.
    end - this instruction indicates that the program ends correctly, so the stored output is returned (if the program terminates without this instruction it should return the default output: see below).
    ; comment - comments should not be taken in consideration during the execution of the program.


Output format:

The normal output format is a string (returned with the end command). For Scala and Rust programming languages it should be incapsulated into Option.

If the program does finish itself without using an end instruction, the default return value is:

-1 (as an integer)


Input format:

The function/method will take as input a multiline string of instructions, delimited with EOL characters. Please, note that the instructions may also have indentation for readability purposes.

For example:

program = "
; My first program
mov  a, 5
inc  a
call function
msg  '(5+1)/2 = ', a    ; output message
end

function:
    div  a, 2
    ret
"
assembler_interpreter(program)

The above code would set register a to 5, increase its value by 1, calls the subroutine function, divide its value by 2, returns to the first call instruction, prepares the output of the program and then returns it with the end instruction. In this case, the output would be (5+1)/2 = 3.

=end

def assembler_interpreter(program)
    coca = program.gsub(/;.*/, '').scan(/'[^']*'|\w+:?/)
    fanta = crispy = 0
    nonstop = {}
    gorila = {}
    green_energy = []
    out = ''
    cocktail = -> x{x[0] == "'" ? x[1..-2] : gorila.fetch(x){x.to_i }}
    jmp = -> {fanta = nonstop[coca[fanta + 1]]}
    tool_box = {
      'jmp' => jmp ,
      'mov' => -> {gorila[coca[fanta += 1]] = cocktail[coca[fanta += 1]]} ,
      'inc' => -> {gorila[coca[fanta += 1]] += 1} ,
      'dec' => -> {gorila[coca[fanta += 1]] -= 1} ,
      'add' => -> {gorila[coca[fanta += 1]] += cocktail[coca[fanta += 1]]} ,
      'sub' => -> {gorila[coca[fanta += 1]] -= cocktail[coca[fanta += 1]]} ,
      'mul' => -> {gorila[coca[fanta += 1]] *= cocktail[coca[fanta += 1]]} ,
      'div' => -> {gorila[coca[fanta += 1]] /= cocktail[coca[fanta += 1]]} ,
      'cmp' => -> {crispy = cocktail[coca[fanta += 1]] - cocktail[coca[fanta += 1]]} ,
      'jne' => -> {crispy == 0 ? (fanta += 1) : jmp.call} ,
      'je'  => -> {crispy == 0 ? jmp.call : (fanta += 1)} ,
      'jge' => -> {crispy < 0 ? (fanta += 1) : jmp.call} ,
      'jg'  => -> {crispy > 0 ? jmp.call : (fanta += 1)} ,
      'jle' => -> {crispy > 0 ? (fanta += 1) : jmp.call} ,
      'jl'  => -> {crispy < 0 ? jmp.call : (fanta += 1)} ,
      'call'=> -> {green_energy.push(fanta += 1); fanta = nonstop[coca[fanta]]} ,
      'ret' => -> {fanta = green_energy.pop } ,
      'msg' => -> {out += cocktail[coca[fanta += 1]].to_s until coca[fanta + 1] == 'end' || tool_box.has_key?(coca[fanta + 1])}
    }
  
    begin
      coca.each.with_index{|t, i| nonstop[t[0..-2]] = i if t[-1] == ':'}
      loop do
        return out if coca[fanta] == 'end'
        tool_box[coca[fanta]].call unless coca[fanta][-1] == ':'
        fanta += 1
      end
    rescue; end
    -1
end  