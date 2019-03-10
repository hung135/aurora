#
# class Class
#   alias old_new new
#   def new(*args)
#     print "Creating a new ", self.name, "\n"
#     old_new(*args)
#   end
# end
class Inventory
    def extract_ipv4(line)
        ip_regex = /(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/
        ip = line[ip_regex]
        ip
    end

    def get_host_group(_hostname)
        groups = []
        @inventory.each do |_key, value|
            # puts value[0][:hostname]
            groups.push(_key) if _hostname == value[0][:hostname]
        end
        groups.push('abc')

        groups
    end

    def read_groups_file(_group)
        require 'yaml'

        groups_yml = YAML.safe_load(File.read('./groups_yml_mapping'))
        x = nil
        groups_yml.each do |_key, _value|
            x = _value if _key == _group
        end

        x
    end

    def extract_additional_storage(line)
        storage = 0
        storage_str = line[/(additional_storage=\d\d\d\d)/]
        storage = storage_str.split('=')[1] unless storage_str.nil?
        storage.to_i
    end

    def get_hostname(line)
        line.split[0]
    end

    # return a dict with all groups passed in
    def get_hosts_by_groups(group_list)
        inventory = {}
        if group_list != nil
            group_list.each do |group|
                inventory[group] = @inventory[group]
            end
        else
            inventory=@inventory 
        end
        inventory
    end

    def initialize(file_path = './vagrant_hosts')
        File.open(file_path, 'r') do |f|
            dictionary = {}
            first_group_found = false
            curr_dict = {}
            array_item = []
            group_mapping = nil
            f.each_line do |line|
                is_group = /\[.*\]/=~line
                idx = nil
                if (first_group_found != true) && is_group
                    # find the first group
                    first_group_found = true
                    idx = line.strip.delete('[]')

                    curr_dict[idx] = array_item
                    group_mapping = read_groups_file(idx)
                elsif is_group
                    dictionary = dictionary.merge(curr_dict)

                    curr_dict = {}
                    array_item = []
                    idx = line.strip.delete('[]')
                    curr_dict[idx] = array_item
                    group_mapping = read_groups_file(idx)
                else

                    ipv4 = extract_ipv4(line)
                    additional_storage = extract_additional_storage(line)

                    if ipv4
                        hostname = get_hostname(line)

                        array_item.push(hostname: hostname,
                                        ipv4: ipv4,

                                        group_mapping: group_mapping)

                    end
                end
            end
            @inventory = {}

            dictionary = dictionary.merge(curr_dict)
            dictionary.each do |key, value|
                next if value.empty?

                # print( value,"---\n")
                @inventory[key] = value

                # puts (key + "\n\t-->" + value*",")
            end
        end
    end
end
