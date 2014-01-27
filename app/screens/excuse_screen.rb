module Screen
  class ExcuseScreen < PM::Screen
    stylesheet :excuse_styles
    # TAGS = { title: 0, instructions_label: 1, authentication_token_field: 2 }

    attr_accessor :date, :week, :is_update

    include Teacup::TableViewDelegate

    @@cell_identifier = nil

    def on_load
      @excuses = []
      self.date
      self.week
      self.is_update
    end

    def will_appear
      super

      @date = self.date || NSDate.today
      @week = self.week || nil
      @is_update = self.is_update || false

      view.subviews.each &:removeFromSuperview
      layout(view, :main_view) do |main_view|
        excuse_table

        subview(UIView, :excuse_nav) do
          @done_btn = subview(UIButton.buttonWithType(UIButtonTypeRoundedRect), :done_btn)
        end

        @done_btn.when_tapped do
          if @excuses.count > 0
            unless @is_update
              create_check_in_with_excuses(@excuses)
            else
              update_check_in_with_excuses(@excuses)
            end
          end
          mm_drawerController.toggleDrawerSide MMDrawerSideRight, animated:true, completion: nil
        end

        # Temporary hack for drawer nav_back 
        subview(UIView, :nav_back) do
          @nav_back_btn = subview(UIButton.buttonWithType(UIButtonTypeRoundedRect), :nav_back_btn)
        end

        @nav_back_btn.when_tapped do
          mm_drawerController.toggleDrawerSide MMDrawerSideRight, animated:true, completion: nil
        end
      end
    end

    def excuse_table
      @data ||= []

      @table_view = subview UITableView.alloc.initWithFrame(self.view.bounds)
      @table_view.dataSource = self
      @table_view.delegate = self
      @table_view.separatorStyle = UITableViewCellSeparatorStyleNone

      Excuse.get_excuses do |success, excuses|
        if success
          @data = excuses   
          @table_view.reloadData
        else
          App.alert("There was an error")
          NSLog("Error getting excuses")
        end
      end
    end

    def tableView(table_view, heightForRowAtIndexPath:index_path)
      60
    end

    def tableView(tableView, numberOfRowsInSection: section)
      @data.count
    end    

    CELLID = 'cell_identifier'
    def tableView(tableView, cellForRowAtIndexPath: indexPath)
      cell = tableView.dequeueReusableCellWithIdentifier(CELLID) || begin
        cell = ExcuseCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CELLID)
        cell.createNameLabel(@data[indexPath.row]['name'])
      end

      if @excuses.include? @data[indexPath.row]['name']
        cell.accessoryType = UITableViewCellAccessoryCheckmark
      else
        cell.accessoryType = UITableViewCellAccessoryNone
      end
      cell
    end

    def tableView(tableView, didSelectRowAtIndexPath: indexPath)
      tableView.deselectRowAtIndexPath(indexPath, animated: true)
      name = @data[indexPath.row]['name']
      updateExcuses(name)
      tableView.reloadData
    end


    def cell_identifier
      @@cell_identifier ||= 'CELL_IDENTIFIER'
    end

    def updateExcuses(excuse_name)
      if @excuses.include? excuse_name
        @excuses.delete(excuse_name)
      else
        @excuses << excuse_name
      end
    end

    def create_check_in_with_excuses(excuses)

      if @week[:small_steps].count > 0
        data = {
          week_id: @week[:id],
          date: @date,
          status: 0, # check ins with excuses are considered to be "NO"
          small_steps: @week[:small_steps],
          excuses: excuses
        }

        CheckIn.create(data) do |success|
          if success
            NSLog("Created check in with excuses")
            screen = mm_drawerController.send(:thank_you_screen)
            mm_drawerController.centerViewController = screen
          else
            App.alert("There was an error")
            NSLog("Error creating check in with excuses")
          end
        end
      end
    end

    def update_check_in_with_excuses(excuses)

      if @week[:small_steps].count > 0
        data = {
          week_id: @week[:id],
          date: @date,
          status: 0, # check ins with excuses are considered to be "NO"
          small_steps: @week[:small_steps],
          excuses: excuses
        }

        check_in = @week[:check_in_id]

        CheckIn.update(data, check_in) do |success|
          if success
            NSLog("Updated check in with excuses")
            screen = mm_drawerController.send(:thank_you_screen)
            mm_drawerController.centerViewController = screen
          else
            App.alert("There was an error")
            NSLog("Error creating check in with excuses")
          end
        end
      end
    end
  end

  class ExcuseCell < UITableViewCell

    attr_accessor :name_label

    def createNameLabel(name)
      @name_label = UILabel.alloc.init
      @name_label.textAlignment = UITextAlignmentLeft
      @name_label.font = UIFont.boldSystemFontOfSize(20)
      @name_label.color = UIColor.orangeColor
      @name_label.text = name

      self.contentView.addSubview(@name_label)
     
      self
    end

    def layoutSubviews
      super

      contentRect = self.contentView.bounds
      boundsX = contentRect.origin.x

      height = self.contentView.height

      @name_label.frame = CGRectMake(boundsX+25, height/2 - 13.5, 200, 25)

    end
  end
end
