class DepBuilder
  def initialize(dep)
    @dep = dep
  end

  def meet(&block)
    @dep.meet_block = block
  end
end
