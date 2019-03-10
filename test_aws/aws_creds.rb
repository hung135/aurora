#
# class Class
#   alias old_new new
#   def new(*args)
#     print "Creating a new ", self.name, "\n"
#     old_new(*args)
#   end
# end
class Aws_Creds
    # return a dict with all groups passed in
    def get_creds(profile)
         
        @inventory[profile]
    end
    def initialize(file_path = '/Users/hnguyen/.aws/credentials')
        File.open(file_path, 'r') do |f|
            dictionary = {}
            first_group_found = false
            curr_dict = {}
            item_dict = {}
            group_mapping = nil
            f.each_line do |line|
                is_group = /\[.*\]/=~line
                idx = nil
                if (first_group_found != true) && is_group
                    # find the first group
                    first_group_found = true
                    idx = line.strip.delete('[]')

                    curr_dict[idx] = item_dict

                elsif is_group
                    dictionary = dictionary.merge(curr_dict)

                    curr_dict = {}
                    array_item = []
                    idx = line.strip.delete('[]')
                    curr_dict[idx] = item_dict

                else
                    if line.length>1
                        cred=line.split('=').map(&:strip)
                        key=cred[0]
                        value=cred[1]
                        item_dict[key]=value
                        #print(array_item,"----\n",line.length,"\n")
                    end




                end
            end

            @inventory = {}

            dictionary = dictionary.merge(curr_dict)

            dictionary.each do |key, value|
                next if value.empty?

                # print( value,"---\n")
                @inventory[key] = value


            end
        end
    end
end
