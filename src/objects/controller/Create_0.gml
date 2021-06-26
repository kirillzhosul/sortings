/// @description Sorting Visualization
// Author: Kirill Zhosul (@kirillzhosul)

#region Initialising.

#region Settings.

// Sorting types.
enum SortingType{
	BubbleSort,
	QuickSortLPS,
	QuickSortHPS
}

// Width of the one line.
#macro __SIZE 8

// Size of the draw array.
#macro __WIDTH floor(room_width / __SIZE)
#macro __HEIGHT room_height

// Dont change.
#macro __OFFSET 1

// Sorting algorithm for implementing.
// SortingType.BubbleSort
__SORTING = SortingType.BubbleSort

#endregion

#region Functions.

#region Sortings algorithms.

function __sorting_bubble_sort(){
	// @function __sorting_bubble_sort()
	// @description Function that implements bubble sort.
	
	// Current sorting index.
	var _current_index = 0;
			
	// Returning if finished.
	if _current_index == __sorting_current_index2{
		// If reached start.
				
		// Finishing.
		__sorting_is_finished = true;
				
		// Returning.
		return;
	}
			
	while(_current_index != __sorting_current_index2){
		// While not reached end.
				
		if __sorted_array[_current_index] > __sorted_array[_current_index+1]{
			// If left bigger than right.
					
			// Swapping.
			__array_swap(__sorted_array, _current_index, _current_index+1);
		}
				
		// Increasing index.
		_current_index ++;
	}
			
	// Not process last line next time.
	__sorting_current_index2 -- ;
}

function __sorting_quick_sort_lps(_l, _r){
	// @function __sorting_quick_sort_lps(_l, _r)
	// @description Function that implements quick sort (Lomuto Partition Scheme).
	
	// If not set defered sortings.
	if _l < _r{
		// If not pivot reached self.
		
		// Getting pivot partition.
		var _pivot = __array_partition_lps(__sorted_array, _l, _r);
		
		// Recursion to 2 parts.
		__sorting_quick_sort_lps(_l, _pivot - 1);
		__sorting_quick_sort_lps(_pivot + 1, _r);
	}
}

function __sorting_quick_sort_hps(_l, _r){
	// @function __sorting_quick_sort_hps(_l, _r)
	// @description Function that implements quick sort (Hoare Partition Scheme).
	
	if _l < _r{
		// If not pivot reached self.
		
		// Getting pivot partition.
		var _pivot = __array_partition_hps(__sorted_array, _l, _r);
		
		// Recursion to 2 parts.
		__sorting_quick_sort_hps(_l, _pivot);
		__sorting_quick_sort_hps(_pivot + 1, _r);
	}
}

#endregion

#region Sortings array mechanics.

function __array_swap(_array, _index_one, _index_two){
	// @function __array_swap(_array, _index_one, _index_two)
	// @description Function that swaps array value.
	
	// Swap buffer.
	var _swap_buffer = _array[@ _index_one];
	
	// Swapping.
	_array[@ _index_one] = _array[@ _index_two];
	_array[@ _index_two] = _swap_buffer;
}

function __array_partition_lps(_array, _l, _r){ 
	// @function __array_partition_lps(_array, _l, _r)
	// @description Function that returns array partition with lomuto partition scheme.
	
	// Getting pivot.
    var _pivot = _array[@ _r];
	
	// Getting iterator.
    var _i = _l;
	
    for (var _j = _l; _j < _r; _j++){
		// Iterating over partition.
		
        if _array[@ _j] < _pivot{
			// If pivot.
			
			// Swapping.
			__array_swap(_array, _i, _j);
			
			// Increasing iterator.
			_i++
		}
	}
	
	// Swapping.
	__array_swap(_array, _i, _r);
	
	// Returning iterator.
    return _i
}

function __array_partition_hps(_array, _l, _r){ 
	// @function __array_partition_lps(_array, _l, _r)
	// @description Function that returns array partition with lomuto partition scheme.
	
	// Getting pivot.
    var _pivot = _array[_l];
	
	// Getting iterators.
    var _i = _l - 1;
    var _j = _r + 1;
	
    while(true){
		// Infinity loop.
		
		// Increasing iterator.
		_i++;
		
		while(_array[@ _i] < _pivot){
			// While not reached pivot.

			// Increasing iterator.
			_i++;
		}

		// Decreasing iterator.
		_j--;
			
		while(_array[@ _j] > _pivot){
			// While not reached pivot.

			// Decreasing iterator.
			_j--;
		}

		// If final - return.
		if _i >= _j return _j;
		
		// Swapping.
		__array_swap(_array, _i, _j);
	}
}

#endregion

#region Visualisation / controlling.

function __get_current_sorting_name(){
	// @function __get_current_sorting_name()
	// @description Function that returns current sorting name as string.
	
	// Default sorting name.
	var _sorting_name = "Not Implemented Sorting";
	
	switch(__SORTING){
		// Bubble sort.
		case SortingType.BubbleSort: _sorting_name = "Bubble Sort"; break;
		case SortingType.QuickSortLPS: _sorting_name = "Quick Sort (Lomuto PS)"; break;
		case SortingType.QuickSortHPS: _sorting_name = "Quick Sort (Hoare PS)"; break;
	}
	
	// Returning quoted sorting name.
	return "\"" + _sorting_name + "\"";
}

function __get_current_state(){
	// @function __get_current_state()
	// @description Function that returns current sorting state.
	
	// If finished returning finished state.
	if __sorting_is_finished return "Finished!"
	
	// Returning sorting state.
	return "Sorting..."
}

function __draw_information(){
	// @function __draw_information()
	// @description Function that draws information about.
	
	// Drawing.
	draw_set_color(c_white);
	draw_set_halign(fa_right);
	draw_text(room_width, 0, __get_current_sorting_name() + "\nState: " + __get_current_state() + "\nControls: R - Restart sorting,\nTAB + R - Regenerate array and restart sorting\nSpace - Switch Pause\nEnter - Switch Sorting");
}

function __hotkeys_process(){
	// @function __hotkeys_process
	// @description Function that processes hotkeys.
	
	if keyboard_check_pressed(ord("R")){
		// Resetting array.

		if keyboard_check(vk_tab){
			// If tab is holded.
				
			// Regenerating unsorted array.
			__regenerate_unsorted_array();
		}
			
		// Resetting sorting.
		__sorting_reset();
	}
	
	if keyboard_check_pressed(vk_enter){
		// Switching sorting.
					
		// Changing sorting.
		if __SORTING == SortingType.BubbleSort{
			__SORTING = SortingType.QuickSortLPS;
		}else{
			if __SORTING == SortingType.QuickSortLPS{
				__SORTING = SortingType.QuickSortHPS;
			}else{
				if __SORTING == SortingType.QuickSortHPS{
					__SORTING = SortingType.BubbleSort;
				}
			}
		}
		
		// Resetting sorting.
		__sorting_reset();
	}
	
	if keyboard_check_pressed(vk_space){
		// Pausing.
		
		// Pause.
		__sorting_is_paused = not __sorting_is_paused;
	}
}

function __sorting_visualize(){
	// @function __sorting_visualize()
	// @description Function that visualizes sorting.
	
	// Processing.
	__sorting_process();
	
	// Drawing information.
	__draw_information();
	
	// Process hotkeys.
	__hotkeys_process();
	
	// Drawing sorting.
	for(var _index = 0; _index < __WIDTH; _index++){
		// For every index.

		// Getting value.
		var _value = __sorted_array[_index];
		
		// Getting x position to draw.
		var _x = _index * __SIZE;

		// Drawing line.
		draw_set_color(c_white);
		draw_rectangle(_x, __HEIGHT, _x + (__SIZE - __OFFSET), _value, false);
		draw_set_color(c_black);
		draw_rectangle(_x + __OFFSET, __HEIGHT, _x + (__SIZE - __OFFSET), _value, true);
	}
}

#endregion

function __sorting_process(){
	// @function __sorting_process()
	// @description Function that process sorting.
	
	// Returning if sound is paused.
	if __sorting_is_paused return;
	
	switch(__SORTING){
		case SortingType.BubbleSort:
			// Implementing Bubble Sorting.
			__sorting_bubble_sort();
		break;
		case SortingType.QuickSortLPS:
			// Implementing Quick Sorting (Lomuto PS).
			__sorting_quick_sort_lps(__sorting_current_index1, __sorting_current_index2);
		break;
		case SortingType.QuickSortHPS:
			// Implementing Quick Sorting (Hoare PS).
			__sorting_quick_sort_hps(__sorting_current_index1, __sorting_current_index2);
		break;
	}
}

function __regenerate_unsorted_array(){
	// @function __regenerate_unsorted_array()
	// @description Function that regenerates unsorted array.
	
	// Deleting
	__unsorted_array = undefined;
	
	// Generating new.
	
	// Randomizing.
	randomize();
	
	// Array.
	__unsorted_array = [];
	
	for(var _index = 0; _index < __WIDTH; _index++){
		// For every index.
		
		// Generating random value.
		__unsorted_array[_index] = irandom_range(0, __HEIGHT);
	}
}

function __sorting_reset(){
	// @function __sorting_reset()
	// @desrciption Function that reset sorting.
	
	// Clearing sorted array.
	__sorted_array = [];
	
	// Copying unsorted array.
	array_copy(__sorted_array, 0, __unsorted_array, 0, array_length(__unsorted_array))
	
	// Sorting is not finished.
	__sorting_is_finished = false;
	
	// Current indeces for sorting.
	__sorting_current_index1 = 0;
	__sorting_current_index2 = __WIDTH - 1;
	
	// list of defered sorting calls.
	__sorting_defered = [];
}

#endregion

#region Variables.

// Unsurted array that used as template for restarting (may be regenerated also).
__unsorted_array = [];

// Sorted array that used as working array (not sorted, just may be sorted as used as working).
__sorted_array = [];

// Is sorting finished or not.
__sorting_is_finished = false;

// Current indeces for sorting.
__sorting_current_index1 = 0;
__sorting_current_index2 = __WIDTH - 1;

// Is sorting pause or not,
__sorting_is_paused = false;

// list of defered sorting calls.
__sorting_defered = [];

#endregion

#region Entry point.

// Regenerating.
__regenerate_unsorted_array();

// Resetting sorting.
__sorting_reset();

#endregion

#endregion