module Ruboty
  module Handlers
    class BingImage < Base
      on /image( me)? (?<keyword>.+)/, name: "image", description: "Search image from Bing"

      def image(message)
        if url = search(message[:keyword])
          message.reply(url)
        end
      end

      private

      def search(query)
        Ruboty::BingImage::Client.new(query: query).get
      end
    end
  end
end
