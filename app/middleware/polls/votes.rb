module Polls
  class Votes
    def initialize(poll)
      @poll = poll
    end

    def results_bad
      @results_bad ||= poll.poll_votes.negative.count
    end

    def results_fine
      @results_fine ||= poll.poll_votes.neutral.count
    end

    def results_good
      @results_good ||= poll.poll_votes.positive.count
    end

    private

    attr_reader :poll
  end
end
