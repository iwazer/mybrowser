class Bookmark < NSManagedObject
  def awakeFromInsert
    super
    setValue(Time.now, forKey: 'created_at')
    setValue(Time.now, forKey: 'updated_at')
    setValue('', forKey: 'title')
    setValue('', forKey: 'url')
    setValue('', forKey: 'memo')
  end

  class << self
    def entity
      @entity ||= begin
        entity = NSEntityDescription.new
        entity.name = 'Bookmark'
        entity.managedObjectClassName = 'Bookmark'
        entity.properties =
          [
            'title', NSStringAttributeType,
            'url', NSStringAttributeType,
            'memo', NSStringAttributeType,
            'created_at', NSDateAttributeType,
            'updated_at', NSDateAttributeType
          ].each_slice(2).map do |name, type|
            property = NSAttributeDescription.new
            property.name = name
            property.attributeType = type
            property.optional = false
            property
        end
        entity
      end
    end
  end
end
