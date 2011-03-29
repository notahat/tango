module Tango
  class CouldNotMeetError   < RuntimeError; end
  class MeetWithoutMetError < RuntimeError; end

  module MetAndMeet

    def met?(&met_block)
      @met_block = met_block
    end

    def meet(&meet_block)
      raise MeetWithoutMetError if @met_block.nil?
      if instance_eval(&@met_block)
        log "already met."
      else
        log "not already met."
        instance_eval(&meet_block)
        if instance_eval(&@met_block)
          log "met."
        else
          raise CouldNotMeetError
        end
      end
    end

  end
end
