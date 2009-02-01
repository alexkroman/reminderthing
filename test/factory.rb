require 'model_factory'
module Factory
  extend ModelFactory

  default Block, {
    :number => '971235729',
    :carrier => 'verizon'
  }


end
