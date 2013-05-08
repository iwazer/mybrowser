class SettingsController < UITableViewController
  attr_writer :delegate

  def viewDidLoad
    super
  end

  def numberOfSectionsInTableView tableView
    1
  end

  def tableView tableView, numberOfRowsInSection:section
    1
  end

  def tableView tableView, titleForHeaderInSection:section
    case section
    when 0
      "連携"
    end
  end

  def tableView tableView, cellForRowAtIndexPath:indexPath
    @@cellIdentifier = "SettingsCell"
    cell = tableView.dequeueReusableCellWithIdentifier(@@cellIdentifier)
    unless cell
      cell = UITableViewCell.alloc.initWithStyle(
        UITableViewCellStyleDefault, reuseIdentifier:@@cellIdentifier)
    end
    cell.textLabel.text = "はてなブックマーク"
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton
    cell
  end

  def tableView tableView, didSelectRowAtIndexPath:indexPath
    url = @store.bookmarks[indexPath.row].url

    @delegate.goto_url = url
    self.navigationController.popViewControllerAnimated(true)
  end
end
