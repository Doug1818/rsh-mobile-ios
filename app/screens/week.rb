module Screen
  class Week < PM::Screen
    
    title 'This Week'

    stylesheet :week_styles
    include Teacup::TableViewDelegate

    def viewWillAppear(animated)
      super

      view.subviews.each &:removeFromSuperview

      layout(view, :main_view) do
        mm_drawerController.title = title

        week_table
        bottom_nav
      end
    end

    def bottom_nav
      y = self.view.bounds.size.height - 30
      label = UILabel.alloc.initWithFrame(CGRect.new([0, y], [self.view.bounds.size.width, 30]))
      label.setAutoresizingMask(1)
      label.backgroundColor = UIColor.blueColor

      self.view.addSubview(label)
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
      puts "DATA COUNT: #{@data.count}"
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
        puts "IN NOT CELL"
        cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleValue1, reuseIdentifier:cell_identifier)
        cell.textLabel.textColor = UIColor.redColor
      else
        puts "IS CELL"
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

    # def viewDidLoad
    # end

    # def tableView(table_view, viewForHeaderInSection:section)
    #   UILabel.alloc.init.tap do |view|
    #     view.backgroundColor = UIColor.clearColor
    #     view.textColor = BW.rgb_color(239, 69, 67)
    #     view.textAlignment = NSTextAlignmentCenter
    #     view.text = section_at_index(section)[:title]
    #   end
    # end
  end
end
