module Screen
  class WeekScreen < PM::Screen

    stylesheet :week_styles
    include Teacup::TableViewDelegate

    @@cell_identifier = nil

    def tableView(table_view, heightForRowAtIndexPath:index_path)
      75
    end

    def on_load
      self.title = ''
    end

    def will_appear
      super

      mm_drawerController.title = title

      view.subviews.each &:removeFromSuperview
      layout(view, :main_view) do |main_view|
        week_table

        subview(UIView, :program_nav) do
          @day_btn = subview(UIButton.buttonWithType(UIButtonTypeRoundedRect), :day_btn)
          @week_btn = subview(UIButton.buttonWithType(UIButtonTypeRoundedRect), :week_btn)
          @month_btn = subview(UIButton.buttonWithType(UIButtonTypeRoundedRect), :month_btn)
        end

        @day_btn.when_tapped do
          screen = mm_drawerController.send(:day_screen)
          mm_drawerController.centerViewController = screen
        end

        @week_btn.when_tapped do
          screen = mm_drawerController.send(:week_screen)
          mm_drawerController.centerViewController = screen
        end

        @month_btn.when_tapped do
          screen = mm_drawerController.send(:month_screen)
          mm_drawerController.centerViewController = screen
        end
      end
    end

    def week_table
      @data ||= []

      @table_view = subview UITableView.alloc.initWithFrame(self.view.bounds)
      @table_view.dataSource = self
      @table_view.delegate = self

      Week.get_weeks do |success, weeks|
        if success
          @data = weeks
          @table_view.reloadData
        else
          App.alert("oops")
        end
      end
    end

    def tableView(tableView, numberOfRowsInSection: section)
      @data.collect {|w| w.days}.flatten.count
    end

    CELLID = 'cell_identifier'
    def tableView(tableView, cellForRowAtIndexPath: indexPath)

      cell = tableView.dequeueReusableCellWithIdentifier(CELLID) || begin
        cell = DayCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CELLID)

        cell.createLabels
        cell
      end

      week = @data
      days = week.collect {|w| w.days}.flatten
      day = days.flatten[indexPath.row]

      date = day['date']
      day_number = day['day_number']
      check_in_status = day['check_in_status']

      cell.date_label.textColor = day['is_future'] ? BW.rgb_color(154,167,164) : BW.rgb_color(113,113,117)
      cell.day_number_label.textColor = day['is_future'] ? BW.rgb_color(250,214,155) : BW.rgb_color(255,160,0)

      cell.day_number_label.text = day_number.to_s
      cell.date_label.text = date.to_s

      cell.check_in_image_view.image = case check_in_status
      when 0
        if day['is_future']
          UIImage.imageNamed('check-in-future.png')
        else
          nil
        end
      when 1
        UIImage.imageNamed('check-in-mixed.png')
      when 2
        UIImage.imageNamed('check-in-yes.png')
      when 3
        UIImage.imageNamed('check-in-no.png')
      else
        nil
      end

      cell
    end

    # Example of tapping a cell
    def tableView(tableView, didSelectRowAtIndexPath: indexPath)
      tableView.deselectRowAtIndexPath(indexPath, animated: true)
      days = @data.collect {|w| w.days}.flatten
      day = days.flatten[indexPath.row]

      date_formatter = NSDateFormatter.alloc.init
      date_formatter.dateFormat = "yyyy-MM-dd"
      date = date_formatter.dateFromString day[:full_date]

      check_in_status = day[:check_in_status]

      if day[:today_or_yesterday]
        if check_in_status == 0
          screen = CheckInScreen.new(nav_bar: true, date: date)
          mm_drawerController.centerViewController = screen
        else
          screen = DayScreen.new(nav_bar: true, date: date)
          mm_drawerController.centerViewController = screen
        end
      end
    end


    def cell_identifier
      @@cell_identifier ||= 'CELL_IDENTIFIER'
    end
  end

  class DayCell < UITableViewCell

    attr_accessor :date_label
    attr_accessor :day_number_label
    attr_accessor :check_in_image_view

    def createLabels
      @date_label = UILabel.alloc.init
      @date_label.textAlignment = UITextAlignmentLeft
      @date_label.font = UIFont.boldSystemFontOfSize(13)

      @day_number_label = UILabel.alloc.init
      @day_number_label.textAlignment = UITextAlignmentLeft
      @day_number_label.font = UIFont.boldSystemFontOfSize(22)

      @check_in_image_view = UIImageView.new

      self.contentView.addSubview(@date_label)
      self.contentView.addSubview(@day_number_label)
      self.contentView.addSubview(@check_in_image_view)

      self
    end

    def layoutSubviews
      super

      contentRect = self.contentView.bounds
      boundsX = contentRect.origin.x

      height = self.contentView.height

      @date_label.frame = CGRectMake(boundsX+25, 5, 200, 15)
      @day_number_label.frame = CGRectMake(boundsX+25, 15, 100, 25)
      @check_in_image_view.frame = CGRectMake(boundsX+240, 0, 79.56, height)

    end

  end
end
