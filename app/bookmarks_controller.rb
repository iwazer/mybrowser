class BookmarksController < UITableViewController
  attr_writer :delegate

  def viewDidLoad
    super
    @store = BookmarkStore.shared
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
      cell = UITableViewCell.alloc.initWithFrame(CGRectZero, reuseIdentifier:@@cellIdentifier)
      cell.textLabel.minimumScaleFactor = 10.0/15
      cell.textLabel.adjustsFontSizeToFitWidth = true
    end
    cell.textLabel.text = @store.bookmarks[indexPath.row].title
    cell
  end

  def tableView tableView, didSelectRowAtIndexPath:indexPath
    url = @store.bookmarks[indexPath.row].url

    @delegate.goto_url = url
    self.navigationController.popViewControllerAnimated(true)
  end
end
