module Screen
  class WeekScreen < PM::Screen

    title 'This Week'

    stylesheet :week_styles
    include Teacup::TableViewDelegate

    def viewWillAppear(animated)
      super

      mm_drawerController.title = title
      # view.subviews.each &:removeFromSuperview

      layout(self.view, :main_view) do
        week_table
        subview(UIView, :program_nav) do
          @day_btn = subview(UIButton.buttonWithType(UIButtonTypeRoundedRect), :day_btn)
          @week_btn = subview(UIButton.buttonWithType(UIButtonTypeRoundedRect), :week_btn)
          @month_btn = subview(UIButton.buttonWithType(UIButtonTypeRoundedRect), :month_btn)
        end

        @day_btn.when_tapped do
          puts "TAPPED DAY BUTTON"
        end

        @week_btn.when_tapped do
          puts "TAPPED WEEK BUTTON"
        end

        @month_btn.when_tapped do
          puts "TAPPED MONTH BUTTON"
        end

      end
    end

    def week_table
      @data = ("A".."Z").to_a

      table_view = UITableView.alloc.initWithFrame(self.view.bounds)
      # table_view = UITableView.alloc.initWithFrame(CGRect.new([0, 64], [self.view.bounds.size.width, 500]))
      table_view.dataSource = self
      table_view.delegate = self

      self.view.addSubview(table_view)
    end

    def tableView(tableView, numberOfRowsInSection: section)
      @data.count
    end

    # When the view is first loaded, the cells don't exist,
    # so we create these cells and set their color to red.
    # When scrolling, new cells are automatically created before
    # this method is called; in this case we're setting the color to blue.
    # At the end, regardless of how the cell was created, we set the text.
    def tableView(tableView, cellForRowAtIndexPath: indexPath)
      cell = tableView.dequeueReusableCellWithIdentifier(cell_identifier)

      unless cell
        cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleValue1, reuseIdentifier:cell_identifier)
        cell.textLabel.textColor = UIColor.redColor
      else
        cell.textLabel.textColor = UIColor.blueColor
      end
      cell.textLabel.text = @data[indexPath.row]

      cell
    end

    # Example of tapping a cell
    def tableView(tableView, didSelectRowAtIndexPath:indexPath)
      tableView.deselectRowAtIndexPath(indexPath, animated: true)
      alert = UIAlertView.alloc.init
      alert.message = "#{@data[indexPath.row]} tapped!"
      alert.addButtonWithTitle "OK"
      alert.show
    end


    def cell_identifier
      @cell_identifier ||= 'CELL_IDENTIFIER'
    end
  end
end
