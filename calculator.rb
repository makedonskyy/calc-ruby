require 'tk'

class Calculator
  def initialize
    @root = TkRoot.new { title "Калькулятор" }
    @result = TkVariable.new
    @first_number = nil
    @operation = nil
    @new_number = true

    create_interface
  end

  def create_interface
    # Создаем поле для ввода
    entry = TkEntry.new(@root) do
      textvariable @result
      justify 'right'
      pack('padx' => 5, 'pady' => 5, 'fill' => 'x')
    end

    # Создаем кнопки
    buttons = [
      ['7', '8', '9', '/'],
      ['4', '5', '6', '*'],
      ['1', '2', '3', '-'],
      ['0', '.', '=', '+']
    ]

    buttons.each do |row|
      frame = TkFrame.new(@root)
      frame.pack('fill' => 'x', 'padx' => 5, 'pady' => 2)
      
      row.each do |button|
        TkButton.new(frame) do
          text button
          width 5
          command proc { button_click(button) }
          pack('side' => 'left', 'padx' => 2, 'pady' => 2, 'fill' => 'x', 'expand' => true)
        end
      end
    end
  end

  def button_click(value)
    case value
    when /[0-9]/
      if @new_number
        @result.value = value
        @new_number = false
      else
        @result.value = @result.value + value
      end
    when '.'
      unless @result.value.include?('.')
        @result.value = @result.value + '.'
        @new_number = false
      end
    when '+', '-', '/', '*'
      @first_number = @result.value.to_f
      @operation = value
      @new_number = true
    when '='
      if @first_number && @operation
        second_number = @result.value.to_f
        case @operation
        when '+'
          @result.value = (@first_number + second_number).to_s
        when '-'
          @result.value = (@first_number - second_number).to_s
        when '/'
          @result.value = second_number.zero? ? 'Ошибка' : (@first_number / second_number).to_s
        when '*'
          @result.value = (@first_number * second_number).to_s
        end
        @first_number = nil
        @operation = nil
        @new_number = true
      end
    end
  end

  def run
    Tk.mainloop
  end
end

calculator = Calculator.new
calculator.run 