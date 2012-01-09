module Tango
  class CouldNotMeetError   < RuntimeError; end
  class MeetWithoutMetError < RuntimeError; end

  module MetAndMeet

    def met?(&met_block)
      @met_block = met_block
    end

    def meet(&meet_block)
      # Cache the met block in case something inside the meet
      # block calls another step with another met block:
      met_block = @met_block

      raise MeetWithoutMetError if met_block.nil?

      if instance_eval(&met_block)
        log "already met."
      else
        log "not already met."

        if !dry_run?
          instance_eval(&meet_block)
          if instance_eval(&met_block)
            log "met."
          else
            raise CouldNotMeetError
          end
        end
      end
    end

    def dry_run?
      !!ENV['TANGO_DRY_RUN']
    end

  end
end
