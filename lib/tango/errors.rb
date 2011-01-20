module Tango
  class StepAlreadyDefinedError < RuntimeError; end
  class UndefinedStepError      < RuntimeError; end
  class CouldNotMeetError       < RuntimeError; end
  class MeetWithoutMetError     < RuntimeError; end
end
