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
	QUICK_SORT_HPS,
	BOGO_SORT
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
	ds_queue_enqueue(sorting_deferred_calls, new sSortingDefferedCall(callable, l, r));
}

#endregion

#region Sorting algorithms.

function sorting_bubble_sort(){
	// @description Bubble sort.
	
	// Current sorting index.
	var current_index = 0;
			
	// Returning if finished.
	if (current_index == sorting_current_index2){
		// If reached start.
				
		// Finishing.
		return;
	}
			
	while(current_index != sorting_current_index2){
		// While not reached end.
				
		if (sorting_sorted_array[current_index] > sorting_sorted_array[current_index + 1]){
			// If left bigger than right.
	
						
			array_push(sorting_draw_selected_indices_l, current_index);
			array_push(sorting_draw_selected_indices_r, current_index + 1);
			
			// Swapping.
			array_swap(sorting_sorted_array, current_index, current_index + 1);
		}
				
		// Increasing index.
		current_index ++;
	}
			
	// Not process last line next time.
	// (Move left).
	sorting_current_index2 -- ;
	
	// Defer next call.
	deferr_call(sorting_bubble_sort, undefined, undefined);
}

function sorting_quick_sort_lps(l, r){
	// @description Quick sort (Lomuto Partition Scheme).
	
	if (l < r){
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
	
	if (l < r){
		// If not pivot reached self.
		
		// Getting pivot partition.
		var pivot = array_partition_hps(sorting_sorted_array, l, r);
		
		// Recursion to 2 parts.
		deferr_call(sorting_quick_sort_hps, l, pivot);
		deferr_call(sorting_quick_sort_hps, pivot + 1, r);
	}
}

function sorting_bogo_sort(){
	// @description Bogo sort.
	var current_index = 0;
			
	while(current_index != sorting_current_index2){
		// While not reached end.

		if (sorting_sorted_array[current_index] > sorting_sorted_array[current_index + 1]){
			// If left bigger than right.
			sorting_regenerate_sorted_array()

			// Restart on next call.
			deferr_call(sorting_bogo_sort, undefined, undefined);
			return;
		}
		current_index ++;
	}
			
	return 
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
		
        if (array[@ j] < pivot){
			// If pivot.
			
			// Swapping.
			array_swap(array, i, j);
			
			// Increasing iterator.
			i++;
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
    var pivot = array[@ l];
	
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
		if (i >= j) return j;
		
		// Swapping.
		array_swap(array, i, j);
	}
	
	// Should be not reachable.
	return -1;
}

function array_in(array, element){
	// @description Returns is array contains that element or not (Using O(n) linear search).
	// @param {array} array Array.
	// @param {any} element Element to search.
	
	// TODO: Binary search instead of linear?.
	// Or use some other data structure.
	// Linear - O(n), Binary -> O(log n)
	
	// Get array size.
	var array_size = array_length(array);
	
	for (var array_index = 0; array_index < array_size; array_index++){
		// Iterate over array.
		
		// Return found if this element.
		if (array[@ array_index] == element) return true;
	}
	
	// Element not exists.
	return false;
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
		case eSORTING_TYPE.BOGO_SORT: sorting_name = "Bogo Sort (Random)"; break;
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
	if (sorting_is_finished) return "Sorted!";
	
	// Returning sorting state.
	return "Sorting...";
}

function draw_information(){
	// @description Draws information about.
	
	// Texts.
	var text_information = "Name: " + get_current_sorting_name() + "\nState: " + get_current_state() + "\nQueue: " + string(ds_queue_size(sorting_deferred_calls));
	var text_controls =  "R [Restart]\nTAB + R [Reset]\nSpace [Pause]\nEnter [Switch]";
	
	// Draw information.
	draw_set_color(c_gray);
	draw_rectangle(0, 0, string_width(text_information), string_height(text_information), false);
	draw_set_color(c_black);
	draw_text(0, 0, text_information);
	
	// Draw constrols.
	draw_set_color(c_gray);
	draw_set_halign(fa_right);
	draw_rectangle(room_width - string_width(text_controls), 0, room_width, string_height(text_controls), false);
	draw_set_color(c_black);
	draw_text(room_width, 0, text_controls);

	// Reset.
	draw_set_halign(fa_left);
	draw_set_color(c_white);
}

function hotkeys_process(){
	// @description Processes hotkeys.
	
	if (keyboard_check_pressed(ord("R"))){
		// Resetting array.

		if (keyboard_check(vk_tab)){
			// If tab is holded.
				
			// Regenerating.
			sorting_regenerate_unsorted_array();
		}
			
		// Resetting.
		sorting_reset();
	}
	
	if (keyboard_check_pressed(vk_enter)){
		// Switching sorting.
				
		// Switching.
		switch(sorting_type){
			case eSORTING_TYPE.BUBBLE_SORT:
				sorting_type = eSORTING_TYPE.QUICK_SORT_LPS;
			break;
			case eSORTING_TYPE.QUICK_SORT_LPS:
				sorting_type = eSORTING_TYPE.QUICK_SORT_HPS;
			break;
			case eSORTING_TYPE.QUICK_SORT_HPS:
				sorting_type = eSORTING_TYPE.BOGO_SORT;
			break;
			case eSORTING_TYPE.BOGO_SORT:
				sorting_type = eSORTING_TYPE.BUBBLE_SORT;
			break;
		}
		
		// Resetting.
		sorting_reset();
	}
	
	if (keyboard_check_pressed(vk_space)){
		// Pausing.
		
		// Pause.
		sorting_is_paused = !sorting_is_paused;
	}
}

function sorting_visualize(){
	// @description Visualizes sorting.

	// Process hotkeys.
	hotkeys_process();
	
	// Drawing sorting.
	for(var array_index = 0; array_index < ARRAY_WIDTH; array_index++){
		// For every index.

		// Getting value.
		var value = sorting_sorted_array[array_index];
		
		// Getting position to draw at.
		var draw_x = array_index * CELL_SIZE;

		// Base color.
		var color = c_white;
		
		// Get color.
		color = array_in(sorting_draw_selected_indices_l, value) ? c_red : (array_in(sorting_draw_selected_indices_r, value) ? c_blue : color);
		
		// Set color.
		draw_set_color(color);
		
		// Draw line.
		draw_rectangle(draw_x, ARRAY_HEIGHT, draw_x + (CELL_SIZE - 1), value, false);
		draw_set_color(c_black);
		draw_rectangle(draw_x + 1, ARRAY_HEIGHT, draw_x + (CELL_SIZE - 1), value, true);
	}
	
	
	// Processing.
	sorting_process();
	
	// Drawing information.
	draw_information();
}

#endregion

function sorting_process(){
	// @description Processes sorting.
	
	// Returning if is paused.
	if (sorting_is_paused) return;

	// Reset draw selection.
	sorting_draw_selected_indices_l = [];
	sorting_draw_selected_indices_r = [];
	
	if (not ds_queue_empty(sorting_deferred_calls)){
		// If we have any deferred calls.
		
		// Get deferred call.
		var deferred_call = ds_queue_dequeue(sorting_deferred_calls);

		// Call deferred function.
		deferred_call.callable(deferred_call.l, deferred_call.r);
		
		if (ds_queue_size(sorting_deferred_calls) == 0){
			// If we not have any deferred calls.
					
			// End sorting.
			sorting_is_finished = true;
		}
	}else{
		// If we dont have any deffered calls.
		
		if (not sorting_is_finished){
			// If we not finished.
			
			// Base case.
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
					// Quick Sorting (Hoare PS).
					callable = sorting_quick_sort_hps;
				break;
				case eSORTING_TYPE.BOGO_SORT:
					// Bogo Sort (Random).
					callable = sorting_bogo_sort;
				break;
			}
			
			if (not is_undefined(callable)){
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
		sorting_unsorted_array[array_index] = irandom_range(0, ARRAY_HEIGHT);
	}
}


function sorting_regenerate_sorted_array(){
	// @description Regenerates sorted array.

	// Clean array.
	sorting_sorted_array = [];
	
	for(var array_index = 0; array_index < ARRAY_WIDTH; array_index++){
		sorting_sorted_array[array_index] = irandom_range(0, ARRAY_HEIGHT);
	}
}


function sorting_reset(){
	// @desrciption Reset sorting.
	
	// Copying unsorted array to sorted (Make sorted array unsorted).
	sorting_sorted_array = [];
	array_copy(sorting_sorted_array, 0, sorting_unsorted_array, 0, array_length(sorting_unsorted_array));
	
	// Reset draw selection.
	sorting_draw_selected_indices_l = [];
	sorting_draw_selected_indices_r = [];
	
	// Reset deferred calls.
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

// Selected draw lines.
sorting_draw_selected_indices_l = [];
sorting_draw_selected_indices_r = [];

// Queue of deferred calls for sorting.
sorting_deferred_calls = ds_queue_create();

// Sorting states.
sorting_is_finished = false;
sorting_is_paused = false;

// Current indices for sorting.
sorting_current_index1 = 0;
sorting_current_index2 = ARRAY_WIDTH - 1;

// Sorting algorithm to execute.
sorting_type = eSORTING_TYPE.BUBBLE_SORT;

#endregion

// Randomizing.
randomize();
	
// Regenerating.
sorting_regenerate_unsorted_array();

// Resetting.
sorting_reset();