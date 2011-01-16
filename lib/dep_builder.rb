class DepBuilder
  def initialize(dep)
    @dep = dep
  end

  def met?(&block)
    @dep.met_block = block
  end

  def meet(&block)
    @dep.meet_block = block
  end
end
