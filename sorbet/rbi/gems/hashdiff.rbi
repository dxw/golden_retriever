# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: strong
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/hashdiff/all/hashdiff.rbi
#
# hashdiff-0.3.8
module HashDiff
  def self.best_diff(obj1, obj2, options = nil, &block); end
  def self.comparable?(obj1, obj2, strict = nil); end
  def self.compare_values(obj1, obj2, options = nil); end
  def self.count_diff(diffs); end
  def self.count_nodes(obj); end
  def self.custom_compare(method, key, obj1, obj2); end
  def self.decode_property_path(path, delimiter = nil); end
  def self.diff(obj1, obj2, options = nil, &block); end
  def self.diff_array_lcs(arraya, arrayb, options = nil); end
  def self.lcs(arraya, arrayb, options = nil); end
  def self.node(hash, parts); end
  def self.patch!(obj, changes, options = nil); end
  def self.prefix_append_array_index(prefix, array_index, opts); end
  def self.prefix_append_key(prefix, key, opts); end
  def self.similar?(obja, objb, options = nil); end
  def self.unpatch!(obj, changes, options = nil); end
end
class HashDiff::LinearCompareArray
  def additions; end
  def append_addition(item, index); end
  def append_addititions_before_match(match_index); end
  def append_deletion(item, index); end
  def append_deletions_before_match(match_index); end
  def append_differences(difference); end
  def call; end
  def changes; end
  def compare_at_index; end
  def deletions; end
  def differences; end
  def expected_additions; end
  def expected_additions=(arg0); end
  def extra_items_in_new_array?; end
  def extra_items_in_old_array?; end
  def index_of_match_after_additions; end
  def index_of_match_after_deletions; end
  def initialize(old_array, new_array, options); end
  def item_difference(old_item, new_item, item_index); end
  def iterated_through_both_arrays?; end
  def new_array; end
  def new_index; end
  def new_index=(arg0); end
  def old_array; end
  def old_index; end
  def old_index=(arg0); end
  def options; end
  def self.call(old_array, new_array, options = nil); end
end
