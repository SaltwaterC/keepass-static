require_relative 'keepass'

module Keepass
  class Database
    def group(name)
      gr = self.groups.select { |g| g.name == name }
      fail "Error: found multiple groups with name #{name}" if gr.length > 1
      gr[0]
    end

    def entry(title, name = nil)
      if name.nil?
        ent = self.entries.select { |e| e.title == title }
        fail "Error: found multiple entries with title #{title}" if ent.length > 1
      else
        begin
          ent = group(name).entries.select { |e| e.title == title }
          fail "Error: found multiple entries with title #{title} for group #{name}" if ent.length > 1
        rescue NoMethodError # if the group doesn't exist
          return nil
        end
      end
      ent[0]
    end
  end
end
