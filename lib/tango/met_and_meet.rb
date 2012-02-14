module Tango
  class CouldNotMeetError   < RuntimeError; end
  class MeetWithoutMetError < RuntimeError; end
  class MustNotMeetError    < RuntimeError; end

  module MetAndMeet

    def met?(&met_block)
      @met_block = met_block
    end

    def met!(&must_not_meet_block)
      @must_not_meet_block = must_not_meet_block
    end

    def meet(&meet_block)
      # Cache the met blocks in case something inside the meet
      # block calls another step with another met block:
      met_block = @met_block
      must_not_meet_block = @must_not_meet_block

      raise MeetWithoutMetError if met_block.nil? && must_not_meet_block.nil?

      met_with_meet(met_block, meet_block) if met_block
      must_not_meet_with_meet(must_not_meet_block, meet_block) if must_not_meet_block
    end

    protected

    def met_with_meet(met_block, meet_block)
      if instance_eval(&met_block)
        log "already met."
      else
        meet_and_ensure_met(met_block, meet_block)
      end
    end

    def must_not_meet_with_meet(met_block, meet_block)
      raise MustNotMeetError if instance_eval(&met_block)
      meet_and_ensure_met(met_block, meet_block)
    end

    def meet_and_ensure_met(met_block, meet_block)
      log "not already met."
      instance_eval(&meet_block)

      if instance_eval(&met_block)
        log "met."
      else
        raise CouldNotMeetError
      end
    end
  end
end
