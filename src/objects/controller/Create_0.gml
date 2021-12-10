/// @description Sorting Visualization
// Author: Kirill Zhosul (@kirillzhosul)

#region Structs.

function sSortingDefferedCall(callable, l, r) constructor{
	// Deffered call structure.
	// Implements container for deffered call.
	// Hold function as callable field.
	// Argument fields.
	
	// Fields.
	self.callable = callable;  // Function to be called.
	self.l = l;  // Left.
	self.r = r;  // Rigth.
}

#endregion

#region Enumerations.

// Sorting types.
enum eSORTING_TYPE{
	BUBBLE_SORT,
	QUICK_SORT_LPS,
	QUICK_SORT_HPS
}

#endregion

#region Macros.

// Width of the line.
#macro CELL_SIZE 8

// Size of the array.
#macro ARRAY_WIDTH floor(room_width / CELL_SIZE)
#macro ARRAY_HEIGHT room_height

#endregion

#region Functions.

#region Deferred calls.

function deferr_call(callable, l, r){
	// @description Deferrs call.
	
	// Deferr.
	return ds_queue_enqueue(sorting_deferred_calls, new sSortingDefferedCall(callable, l, r));
}

#endregion

#region Sorting algorithms.

function sorting_bubble_sort(){
	// @description Bubble sort.
	
	// Current sorting index.
	var current_index = 0;
			
	// Returning if finished.
	if current_index == sorting_current_index2{
		// If reached start.
				
		// Finishing.
		sorting_is_finished = true;
				
		// Returning.
		return;
	}
			
	while(current_index != sorting_current_index2){
		// While not reached end.
				
		if sorting_sorted_array[current_index] > sorting_sorted_array[current_index + 1]{
			// If left bigger than right.
					
			// Swapping.
			array_swap(sorting_sorted_array, current_index, current_index + 1);
		}
				
		// Increasing index.
		current_index ++;
	}
			
	// Not process last line next time.
	// (Move left).
	sorting_current_index2 -- ;
}

function sorting_quick_sort_lps(l, r){
	// @description Quick sort (Lomuto Partition Scheme).
	
	if l < r{
		// If not pivot reached self.
		
		// Getting pivot partition.
		var pivot = array_partition_lps(sorting_sorted_array, l, r);
		
		// Recursion to 2 parts.
		deferr_call(sorting_quick_sort_lps, l, pivot - 1);
		deferr_call(sorting_quick_sort_lps, pivot + 1, r);
	}
}

function sorting_quick_sort_hps(l, r){
	// @description Quick sort (Hoare Partition Scheme).
	
	if l < r{
		// If not pivot reached self.
		
		// Getting pivot partition.
		var pivot = array_partition_hps(sorting_sorted_array, l, r);
		
		// Recursion to 2 parts.
		deferr_call(sorting_quick_sort_hps, l, pivot);
		deferr_call(sorting_quick_sort_hps, pivot + 1, r);
	}
}

#endregion

#region Sorting array mechanics.

function array_swap(array, src, dst){
	// @description Swaps array value.
	
	// Swap buffer.
	var buffer = array[@ dst];
	
	// Swapping.
	array[@ dst] = array[@ src];
	array[@ src] = buffer;
}

function array_partition_lps(array, l, r){ 
	// @description Aarray partition with lomuto partition scheme.
	
	// Getting pivot.
    var pivot = array[@ r];
	
	// Getting iterator.
    var i = l;
	
    for (var j = l; j < r; j++){
		// Iterating over partition.
		
        if array[@ j] < pivot{
			// If pivot.
			
			// Swapping.
			array_swap(array, i, j);
			
			// Increasing iterator.
			i++
		}
	}
	
	// Swapping.
	array_swap(array, i, r);
	
	// Returning iterator.
    return i;
}

function array_partition_hps(array, l, r){ 
	// @description Aarray partition with lomuto partition scheme.
	
	// Getting pivot.
    var pivot = array[l];
	
	// Getting iterators.
    var i = l - 1;
    var j = r + 1;
	
    while(true){
		// Infinity loop.
		
		// Increasing iterator.
		i++;
		
		while(array[@ i] < pivot){
			// While not reached pivot.

			// Increasing iterator.
			i++;
		}

		// Decreasing iterator.
		j--;
			
		while(array[@ j] > pivot){
			// While not reached pivot.

			// Decreasing iterator.
			j--;
		}

		// If final - return.
		if i >= j return j;
		
		// Swapping.
		array_swap(array, i, j);
	}
	
	// Should be not reachable.
	return -1;
}

#endregion

#region Visualisation / controlling.

function get_current_sorting_name(){
	// @description Returns current sorting name as string.
	// @returns {string} Sorting Name.
	
	// Default sorting name.
	var sorting_name = "Not Implemented Sorting";
	
	switch(sorting_type){
		// Bubble sort.
		case eSORTING_TYPE.BUBBLE_SORT: sorting_name = "Bubble Sort"; break;
		case eSORTING_TYPE.QUICK_SORT_LPS: sorting_name = "Quick Sort (Lomuto PS)"; break;
		case eSORTING_TYPE.QUICK_SORT_HPS: sorting_name = "Quick Sort (Hoare PS)"; break;
	}
	
	// Returning quoted sorting name.
	return "\"" + sorting_name + "\"";
}

function get_current_state(){
	// @description Returns current sorting state.
	// @returns {string} State
	
	// If finished returning finished state.
	if sorting_is_finished return "Finished!"
	
	// Returning sorting state.
	return "Sorting..."
}

function draw_information(){
	// @description Draws information about.
	
	// Drawing.
	draw_set_color(c_white);
	draw_set_halign(fa_right);
	draw_text(room_width, 0, get_current_sorting_name() + "\nState: " + get_current_state() + "\nControls: R - Restart sorting,\nTAB + R - Regenerate array and restart sorting\nSpace - Switch Pause\nEnter - Switch Sorting");
}

function hotkeys_process(){
	// @description Processes hotkeys.
	
	if keyboard_check_pressed(ord("R")){
		// Resetting array.

		if keyboard_check(vk_tab){
			// If tab is holded.
				
			// Regenerating.
			sorting_regenerate_unsorted_array();
		}
			
		// Resetting.
		sorting_reset();
	}
	
	if keyboard_check_pressed(vk_enter){
		// Switching sorting.
				
		// Switching.
		switch(sorting_type){
			case eSORTING_TYPE.BUBBLE_SORT:
				sorting_type = eSORTING_TYPE.QUICK_SORT_LPS
			break;
			case eSORTING_TYPE.QUICK_SORT_LPS:
				sorting_type = eSORTING_TYPE.QUICK_SORT_HPS
			break;
			case eSORTING_TYPE.QUICK_SORT_HPS:
				sorting_type = eSORTING_TYPE.BUBBLE_SORT
			break;
		}
		

		// Resetting.
		sorting_reset();
	}
	
	if keyboard_check_pressed(vk_space){
		// Pausing.
		
		// Pause.
		sorting_is_paused = !sorting_is_paused;
	}
}

function sorting_visualize(){
	// @description Visualizes sorting.
	
	// Processing.
	sorting_process();
	
	// Drawing information.
	draw_information();
	
	// Process hotkeys.
	hotkeys_process();
	
	// Drawing sorting.
	for(var array_index = 0; array_index < ARRAY_WIDTH; array_index++){
		// For every index.

		// Getting value.
		var value = sorting_sorted_array[array_index];
		
		// Getting position to draw at.
		var draw_x = array_index * CELL_SIZE;

		// Drawing line.
		draw_set_color(c_white);
		draw_rectangle(draw_x, ARRAY_HEIGHT, draw_x + (CELL_SIZE - 1), value, false);
		draw_set_color(c_black);
		draw_rectangle(draw_x + 1, ARRAY_HEIGHT, draw_x + (CELL_SIZE - 1), value, true);
	}
}

#endregion

function sorting_process(){
	// @description Processes sorting.
	
	// Returning if is paused.
	if sorting_is_paused return;
	
	if not ds_queue_empty(sorting_deferred_calls){
		// If we have any deffered calls.
		
		while (true){
			// Iterate over all deffered calls.
			
			// Get deffered call.
			var deffered_call = ds_queue_dequeue(sorting_deferred_calls);
			
			// Go out if reach end.
			if is_undefined(deffered_call) break;
			
			// Call defered function.
			deffered_call.callable(deffered_call.l, deffered_call.r);
		}
		
		// Reset deffered calls.
		ds_queue_clear(sorting_deferred_calls);
	}else{
		// If we dont have any deffered calls.
		
		if not sorting_is_finished{
			// If we not finished.
			
			var callable = undefined;
			// Start call.
			switch(sorting_type){
				case eSORTING_TYPE.BUBBLE_SORT:
					// Bubble Sorting.
					callable = sorting_bubble_sort;
				break;
				case eSORTING_TYPE.QUICK_SORT_LPS:
					// Quick Sorting (Lomuto PS).
					callable = sorting_quick_sort_lps;
				break;
				case eSORTING_TYPE.QUICK_SORT_HPS:
					//Quick Sorting (Hoare PS).
					callable = sorting_quick_sort_hps;
				break;
			}
			
			if not is_undefined(callable){
				// If we have callable.
				
				// Call that callable.
				callable(sorting_current_index1, sorting_current_index2);
			}
		}
	}

}

function sorting_regenerate_unsorted_array(){
	// @description Regenerates unsorted array.

	// Clean array.
	sorting_unsorted_array = [];
	
	for(var array_index = 0; array_index < ARRAY_WIDTH; array_index++){
		// For every index.
		
		// Generating random value.
		sorting_unsorted_array[array_index] = irandom_range(0, ARRAY_HEIGHT);
	}
}

function sorting_reset(){
	// @desrciption Reset sorting.
	
	// Copying unsorted array to sorted (Make sorted array unsorted).
	sorting_sorted_array = [];
	array_copy(sorting_sorted_array, 0, sorting_unsorted_array, 0, array_length(sorting_unsorted_array))
	
	// Reset deffered calls.
	ds_queue_clear(sorting_deferred_calls);
	
	// Sorting is not finished.
	sorting_is_finished = false;
	
	// Current indices for sorting.
	sorting_current_index1 = 0;
	sorting_current_index2 = ARRAY_WIDTH - 1;
}

#endregion

#region Variables.

// Arrays.
// Unsorted array that used when resetting via `regenerate_unsorted_array()`.
sorting_unsorted_array = [];
sorting_sorted_array = [];

// Queue of deffered calls for sorting.
sorting_deferred_calls = ds_queue_create();

// Sorting states.
sorting_is_finished = false;
sorting_is_paused = false;

// Current indices for sorting.
sorting_current_index1 = 0;
sorting_current_index2 = ARRAY_WIDTH - 1;

// Sorting algorithm to execute.
sorting_type = eSORTING_TYPE.BUBBLE_SORT

#endregion

// Randomizing.
randomize();
	
// Regenerating.
sorting_regenerate_unsorted_array();

// Resetting.
sorting_reset();