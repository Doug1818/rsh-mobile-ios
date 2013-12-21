module Screen
  class TodosScreen < PM::GroupedTableScreen
    title 'To Dos'
    def will_appear
      mm_drawerController.title = title
    end

    stylesheet :schedule_styles
    include Teacup::TableViewDelegate

    def will_appear
      # move down for nav menu
      table_view.top = TOP_BELOW_MM_NAV
      table_view.height = table_view.superview.height - table_view.top
    end

    def table_data
      [{
        cells: [
          { title: "...", action: :tapped_first_name },
        ]
      }]
    end

    def tableView(table_view, viewForHeaderInSection:section)
      UILabel.alloc.init.tap do |view|
        view.backgroundColor = UIColor.clearColor
        view.textColor = BW.rgb_color(239, 69, 67)
        view.textAlignment = NSTextAlignmentCenter
        view.text = section_at_index(section)[:title]
      end
    end
  end
end
