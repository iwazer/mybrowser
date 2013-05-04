class BookmarkStore
  class << self
    def shared
      @shared ||= BookmarkStore.new
    end
  end

  def bookmarks params={}
    @bookmarks ||= begin
      request = NSFetchRequest.new
      request.entity = NSEntityDescription.entityForName('Bookmark', inManagedObjectContext:@context)
      request.sortDescriptors = [NSSortDescriptor.alloc.initWithKey('created_at', ascending:false)]
      limit = params[:limit] || 10
      start = params[:start] || 0
      request.setFetchLimit(limit)
      request.setFetchOffset(start)

      error_ptr = Pointer.new(:object)
      data = @context.executeFetchRequest(request, error:error_ptr)
      raise "Error when fetching data: #{error_ptr[0].description}" if data == nil
      data
    end
  end

  def addEntry
    yield NSEntityDescription.insertNewObjectForEntityForName('Bookmark', inManagedObjectContext:@context)
    save
  end

  def updateEntry id, attributes = {}
    error_ptr = Pointer.new(:object)
    entry = @context.existingObjectWithID(id, error:error_ptr)
    attributes.each do |key, value|
      entry.send("#{key}=", value) if entry.respond_to?(key)
    end
    entry.updated_at = Time.now
    save
  end

  def removeBookmark entry
    @context.deleteObject(entry)
    save
  end

  private

  def initialize
    model = NSManagedObjectModel.new
    model.entities = [Bookmark.entity] # this is how you use the self.entity method from earlier

    store = NSPersistentStoreCoordinator.alloc.initWithManagedObjectModel(model)
    store_url = NSURL.fileURLWithPath(File.join(NSHomeDirectory(), 'Documents', 'Bookmarks.sqlite'))
    error_ptr = Pointer.new(:object)
    raise "Can't add persistent SQLite store: #{error_ptr[0].description}" unless store.addPersistentStoreWithType(NSSQLiteStoreType, configuration:nil, URL:store_url, options:nil, error:error_ptr)

    context = NSManagedObjectContext.new
    context.persistentStoreCoordinator = store
    @context = context
  end

  def save
    error_ptr = Pointer.new(:object)
    raise "Error when saving the model: #{error_ptr[0].description}" unless @context.save(error_ptr)
    @bookmarks = nil
  end
end
