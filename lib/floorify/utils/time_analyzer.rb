module Floorify
  class TimeAnalyzer

    def initialize(time)
      @time = time
    end

    def minutes_ago?(count)
      include_minutes_word? ? (get_minutes <= count) : false
    end

    private

      def include_minutes_word?
        @time.include? "minutos"
      end

      def get_minutes
        @time.gsub("minutos", "").strip.to_i
      end
  end
end
