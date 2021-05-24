module Operation
  class Rbp < Base
    def initialize(command)
      super
      ::Rbp::Container.register("operation.#{command}.messages", [])
    end

    def call(section, **kwargs)
      messages = ::Rbp::Container["operation.#{@command}.messages"].reject(&:empty?).join("\n").strip
      ::Rbp::Container["operation.#{@command}.messages"].filter! { false }

      command = Rofi.call(
        section.to_s,
        section.all.reject { |s| s.id == section.id },
        mesg: (messages unless messages.empty?)
      )
      selection = section.parser.call(
        command,
        hosting_section: section
      )

      if selection&.valid?
        if selection.operation.instance_of?(self.class) && selection.id != section.id
          try_create_links(section, selection)
        else
          section.find_or_create(selection.to_s)
        end

        next_section, save = selection.execute(hosting_section: section)

        section.remove(selection.to_s) unless save
        [next_section, save]
      elsif !command.empty?
        ::Rbp::Container["operation.rbp.messages"] << "Command (#{command}) failed."
        section.execute
      else
        [nil, nil]
      end
    end

    def try_remove_links(hosting_section, new_section)
    end

    def bookmark_type
      ::Bookmark::Section
    end

    private

    # file source dependent??
    def try_create_links(hosting_section, new_section)
      # if we're in the same directory, try to create bookmarks in both the
      # hosting section and the new rbp new_section
      if hosting_section.source.input.dirname == new_section.source.input.dirname
        new_section.find_or_create(hosting_section.to_s(parent: 0))
        hosting_section.find_or_create(new_section.to_s(parent: 0))
      # otherwise, try traversals both directions to find who the parent folder is and create bookmarks
      else
        # TODO: Prevent creating files out of main runners source.input? or similar?
        new_section.source.input.ascend.with_index do |v, i|
          if v.dirname == hosting_section.source.input.dirname
            hosting_section.find_or_create(new_section.to_s(child: i))
            new_section.find_or_create(hosting_section.to_s(parent: i))
            break
          end
        end

        hosting_section.source.input.ascend.with_index do |v, i|
          if v.dirname == new_section.source.input.dirname
            hosting_section.find_or_create(new_section.to_s(parent: i))
            new_section.find_or_create(hosting_section.to_s(child: i))
            break
          end
        end
      end
    end
  end
end
