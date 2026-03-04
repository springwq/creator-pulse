module Contents
  class Create
    def initialize(creator_id, params)
      @creator_id = creator_id
      @params = params
    end

    def call
      creator = Creator.find_by(id: @creator_id)
      return BaseResult.failure({ creator: [ 'not found' ] }) unless creator

      content = creator.contents.build(@params)

      if content.save
        BaseResult.success(content)
      else
        BaseResult.failure(content.errors.to_hash)
      end
    end
  end
end
