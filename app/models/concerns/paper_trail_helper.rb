module PaperTrailHelper
  extend ActiveSupport::Concern

  included do
    def trails_to_builder
      trails.reverse.map do |trail|
        {
              event: trail.event,
               time: trail.created_at,
            changes: trail.changeset, # TODO: this method may load item record every time!
              admin: trail.whodunnit
        }
      end
    end

    def add_trail(change)
      PaperTrail::Version.create(
               item_type: self.class.name,
                 item_id: self.id,
                   event: 'update ' + change.keys.first,
          object_changes: change.to_yaml
      )
    end
  end

  class_methods do
    def has_trail(ignore: [])
      has_paper_trail ignore: %i[ created_at updated_at ] + ignore, versions: :trails, version: :trail
      scope :with_trails, -> { includes(:trails) }
    end

    def trails_to_builder
      with_trails.map(&:trails_to_builder)
    end
  end
end
