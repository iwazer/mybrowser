class BookmarksController < UITableViewController
  attr_writer :delegate

  def viewDidLoad
    super
    @store = BookmarkStore.shared
    self.navigationItem.rightBarButtonItem = self.editButtonItem
  end

  def numberOfSectionsInTableView tableView
    1
  end

  def tableView tableView, numberOfRowsInSection:section
    @store.bookmarks.length
  end

  def tableView tableView, cellForRowAtIndexPath:indexPath
    @@cellIdentifier = "BookmarkCell"
    cell = tableView.dequeueReusableCellWithIdentifier(@@cellIdentifier)
    unless cell
      cell = UITableViewCell.alloc.initWithStyle(
        UITableViewCellStyleSubtitle, reuseIdentifier:@@cellIdentifier)
      cell.textLabel.minimumScaleFactor = 10.0/15
      cell.textLabel.adjustsFontSizeToFitWidth = true
    end
    bookmark = @store.bookmarks[indexPath.row]
    cell.textLabel.text = bookmark.title
    cell.detailTextLabel.text = bookmark.url
    cell
  end

  def tableView tableView, didSelectRowAtIndexPath:indexPath
    url = @store.bookmarks[indexPath.row].url

    @delegate.goto_url = url
    self.navigationController.popViewControllerAnimated(true)
  end

  ### Edit

  def tableView tableView, canEditRowAtIndexPath:indexPath
    true
  end

  def tableView tableView, commitEditingStyle:editingStyle, forRowAtIndexPath:indexPath
    store = BookmarkStore.shared
    bookmark = store.bookmarks[indexPath.row]
    store.remove(bookmark)
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:true)
  end
end
