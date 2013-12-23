module Screen
  class WeekScreen < PM::Screen

    title 'This Week'

    @@cell_identifier = nil

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
      @data ||= []

      @table_view = UITableView.alloc.initWithFrame(self.view.bounds)
      @table_view.dataSource = self
      self.view.addSubview(@table_view)
      # @table_view.delegate = self

      Week.get_week do |success, week|
        if success
          @data = week
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

      week = @data.collect
      days = week.collect {|w| w.days}.flatten
      day = days.flatten[indexPath.row]

      date = day['date']
      day_number = day['day_number']
      check_in_status = day['check_in_status']

      cell.date_label.textColor = day['is_future'] ? BW.rgb_color(154,167,164) : BW.rgb_color(113,113,117)
      cell.day_number_label.textColor = day['is_future'] ? BW.rgb_color(250,214,155) : BW.rgb_color(255,160,0) 

      cell.day_number_label.text = day_number.to_s
      cell.date_label.text = date.to_s

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
      @@cell_identifier ||= 'CELL_IDENTIFIER'
    end
  end

  class DayCell < UITableViewCell
 
    attr_accessor :date_label
    attr_accessor :day_number_label
   
    def createLabels
   
      @date_label = UILabel.alloc.init
      @date_label.textAlignment = UITextAlignmentLeft
      @date_label.font = UIFont.boldSystemFontOfSize(10)
   
      @day_number_label = UILabel.alloc.init
      @day_number_label.textAlignment = UITextAlignmentLeft
      @day_number_label.font = UIFont.boldSystemFontOfSize(14)
   
      self.contentView.addSubview(@date_label)
      self.contentView.addSubview(@day_number_label)
   
      self
    end
   
    def layoutSubviews
      super
   
      contentRect = self.contentView.bounds
      boundsX = contentRect.origin.x
   
      @date_label.frame = CGRectMake(boundsX+25, 5, 200, 15)
      @day_number_label.frame = CGRectMake(boundsX+25, 15, 100, 25)
   
    end
   
  end
end
