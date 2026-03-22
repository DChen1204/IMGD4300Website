// Determine if a pixel is inside the given rectangle
// st: the normalized position of the pixel
// pos: the center position of the rectangle
// size: the dimension of the rectangle
// Returns 1 is the pixel is inside the rectangle, otherwise return 0
fn drawShape(st: vec2f, pos: vec2f, size: vec2f) -> f32 {
    
    // Reverse the y rectangle position for Schwartz
    let screenPos = vec2f(pos.x, 1.0 - pos.y);

    // Define the boundaries of the rectangle
    let left = screenPos.x - (size.x * 0.5);
    let right = screenPos.x + (size.x * 0.5);
    let top = screenPos.y + (size.y * 0.5);
    let bottom = screenPos.y - (size.y * 0.5);

    // Check if the pixel is within the boundaries
    let insideMask = (step(left, st.x) - step(right, st.x)) * (step(bottom, st.y) - step(top, st.y));
    return insideMask;
}

@fragment 
fn fs(@builtin(position) pos : vec4f) -> @location(0) vec4f {
    
		// Get the time
    let t = seconds();

		// Normalize pixel coordinate
    let st = fract(uvN(pos.xy));

		// Rotation coordinate
		// Convert it to a square coordinate first, rotate, then change it back
		var st_rot = st;
		var st_rot2 = st;

		let aspect = res.x / res.y;
		st_rot.x *= aspect;
		st_rot2.x *= aspect;

		st_rot = rotate(st_rot, t);
		st_rot2 = rotate(st_rot2, -t);
		
		st_rot /= aspect;
		st_rot2 /= aspect;


    // y positions over time for horizontal lines moving up	
    let hLine1_yPos = (t % 7.0) * 0.3;
    let hLine2_yPos = ((t % 7.0) * 0.3) - 0.2; 
    let hLine3_yPos = ((t % 7.0) * 0.3) - 0.7; 

    // y positions over time for horizontal lines moving down
    let hLine1_yPos2 = (7.0 - (t % 7.0)) * 0.3;
    let hLine2_yPos2 = (7.0 - (t % 7.0)) * 0.3 - 0.2; 
    let hLine3_yPos2 = (7.0 - (t % 7.0)) * 0.3 - 0.7; 

		// y positions over time for horizontal lines bouncing up and down
		let hLine1_yPos3 = abs((t % 14.0) - 7.0) * 0.24;
		let hLine2_yPos3 = abs((t % 14.0) - 7.0) * 0.24 - 0.2;
		let hLine3_yPos3 = abs((t % 14.0) - 7.0) * 0.24 - 0.7;

    // x positions over time for vertical lines moving right
    let vLine1_xPos = (t % 7.0) * 0.3 - 0.9; 
    let vLine2_xPos = ((t % 7.0) * 0.3) - 0.75; 
    let vLine3_xPos = ((t % 7.0) * 0.3) - 0.25;
    let vLine4_xPos = ((t % 7.0) * 0.3);

    // x positions over time for vertical lines moving left
    let vLine1_xPos2 = (7.0 - (t % 7.0)) * 0.3 - 0.9; 
    let vLine2_xPos2 = ((7.0 - (t % 7.0)) * 0.3) - 0.75; 
    let vLine3_xPos2 = ((7.0 - (t % 7.0)) * 0.3) - 0.25;
    let vLine4_xPos2 = ((7.0 - (t % 7.0)) * 0.3);

		// x positions over time for vertical lines boucing up and down
		let vLine1_xPos3 = abs((t % 14.0) - 7.0) * 0.27 - 0.9;
		let vLine2_xPos3 = abs((t % 14.0) - 7.0) * 0.27 - 0.75;
		let vLine3_xPos3 = abs((t % 14.0) - 7.0) * 0.27 - 0.25;
		let vLine4_xPos3 = abs((t % 14.0) - 7.0) * 0.27;

    // Colors
    var color = vec4f(1.0, 1.0, 1.0, 1.0);
    let red = vec4f(0.7, 0.0, 0.0, 1.0);
    let yellow = vec4f(1.0, 0.88, 0.0, 1.0);
    let blue = vec4f(0.0, 0.47, 0.95, 1.0);

    // Lines
    var hLine1: f32;
    var hLine2: f32;
    var hLine3: f32;
    var vLine1: f32;
    var vLine2: f32;
    var vLine3: f32;
    var vLine4: f32;

    // Animation
    if (t < 9.67) {
	// Phase 1: 0 - 9.67
	// Static image
        hLine1 = drawShape(st, vec2f(0.5, 0.8), vec2f(1.0, 0.05));
        hLine2 = drawShape(st, vec2f(0.5, 0.6), vec2f(1.0, 0.05));
        hLine3 = drawShape(st, vec2f(0.6, 0.1), vec2f(0.8, 0.05));
        vLine1 = drawShape(st, vec2f(0.05, 0.8), vec2f(0.025, 0.4));
        vLine2 = drawShape(st, vec2f(0.2, 0.5), vec2f(0.025, 1.0));    
        vLine3 = drawShape(st, vec2f(0.7, 0.5), vec2f(0.025, 1.0));
        vLine4 = drawShape(st, vec2f(0.95, 0.5), vec2f(0.025, 1.0));
    } else if (t < 23.67) {
	// Phase 2: 9.67 - 23.67
	// hLine1 starts moving up
        hLine1 = drawShape(st, vec2f(0.5, hLine1_yPos), vec2f(1.0, 0.05));
        hLine2 = drawShape(st, vec2f(0.5, 0.6), vec2f(1.0, 0.05));
        hLine3 = drawShape(st, vec2f(0.6, 0.1), vec2f(0.8, 0.05));
        vLine1 = drawShape(st, vec2f(0.05, 0.8), vec2f(0.025, 0.4));
        vLine2 = drawShape(st, vec2f(0.2, 0.5), vec2f(0.025, 1.0));    
        vLine3 = drawShape(st, vec2f(0.7, 0.5), vec2f(0.025, 1.0));
        vLine4 = drawShape(st, vec2f(0.95, 0.5), vec2f(0.025, 1.0));
    } else if (t < 37.67) {
	// Phase 3: 23.67 - 37.67
	// hLine2 starts moving up
        hLine1 = drawShape(st, vec2f(0.5, hLine1_yPos), vec2f(1.0, 0.05));
        hLine2 = drawShape(st, vec2f(0.5, hLine2_yPos), vec2f(1.0, 0.05));
        hLine3 = drawShape(st, vec2f(0.6, 0.1), vec2f(0.8, 0.05));
        vLine1 = drawShape(st, vec2f(0.05, 0.8), vec2f(0.025, 0.4));
        vLine2 = drawShape(st, vec2f(0.2, 0.5), vec2f(0.025, 1.0));    
        vLine3 = drawShape(st, vec2f(0.7, 0.5), vec2f(0.025, 1.0));
        vLine4 = drawShape(st, vec2f(0.95, 0.5), vec2f(0.025, 1.0));
    } else if (t < 51.67) {
	// Phase 4: 37.67 - 51.67
	// hLine3 starts moving up
        hLine1 = drawShape(st, vec2f(0.5, hLine1_yPos), vec2f(1.0, 0.05));
        hLine2 = drawShape(st, vec2f(0.5, hLine2_yPos), vec2f(1.0, 0.05));
        hLine3 = drawShape(st, vec2f(0.6, hLine3_yPos), vec2f(0.8, 0.05));
        vLine1 = drawShape(st, vec2f(0.05, 0.8), vec2f(0.025, 0.4));
        vLine2 = drawShape(st, vec2f(0.2, 0.5), vec2f(0.025, 1.0));    
        vLine3 = drawShape(st, vec2f(0.7, 0.5), vec2f(0.025, 1.0));
        vLine4 = drawShape(st, vec2f(0.95, 0.5), vec2f(0.025, 1.0));
    } else if (t < 52.17) {
	// Phase 5: 51.67 - 52.17 
	// hLines stop moving 
        hLine1 = drawShape(st, vec2f(0.5, 0.8), vec2f(1.0, 0.05));
        hLine2 = drawShape(st, vec2f(0.5, 0.6), vec2f(1.0, 0.05));
        hLine3 = drawShape(st, vec2f(0.6, 0.1), vec2f(0.8, 0.05));
        vLine1 = drawShape(st, vec2f(0.05, 0.8), vec2f(0.025, 0.4));
        vLine2 = drawShape(st, vec2f(0.2, 0.5), vec2f(0.025, 1.0));    
        vLine3 = drawShape(st, vec2f(0.7, 0.5), vec2f(0.025, 1.0));
        vLine4 = drawShape(st, vec2f(0.95, 0.5), vec2f(0.025, 1.0));
    } else if (t < 66.17) {
	// Phase 6: 52.17 - 66.17
	// vLine1 starts moving right 
        hLine1 = drawShape(st, vec2f(0.5, 0.8), vec2f(1.0, 0.05));
        hLine2 = drawShape(st, vec2f(0.5, 0.6), vec2f(1.0, 0.05));
        hLine3 = drawShape(st, vec2f(0.6, 0.1), vec2f(0.8, 0.05));
        vLine1 = drawShape(st, vec2f(vLine1_xPos, 0.8), vec2f(0.025, 0.4));
        vLine2 = drawShape(st, vec2f(0.2, 0.5), vec2f(0.025, 1.0));
        vLine3 = drawShape(st, vec2f(0.7, 0.5), vec2f(0.025, 1.0));
        vLine4 = drawShape(st, vec2f(0.95, 0.5), vec2f(0.025, 1.0));
    } else if (t < 80.17) {
	// Phase 7: 66.17 - 80.17
	// vLine2 starts moving right
        hLine1 = drawShape(st, vec2f(0.5, 0.8), vec2f(1.0, 0.05));
        hLine2 = drawShape(st, vec2f(0.5, 0.6), vec2f(1.0, 0.05));
        hLine3 = drawShape(st, vec2f(0.6, 0.1), vec2f(0.8, 0.05));
        vLine1 = drawShape(st, vec2f(vLine1_xPos, 0.8), vec2f(0.025, 0.4));
        vLine2 = drawShape(st, vec2f(vLine2_xPos, 0.5), vec2f(0.025, 1.0));
        vLine3 = drawShape(st, vec2f(0.7, 0.5), vec2f(0.025, 1.0));
        vLine4 = drawShape(st, vec2f(0.95, 0.5), vec2f(0.025, 1.0));
    } else if (t < 94.17) {
	// Phase 8: 80.17 - 94.17
	// vLine3 starts moving right 
        hLine1 = drawShape(st, vec2f(0.5, 0.8), vec2f(1.0, 0.05));
        hLine2 = drawShape(st, vec2f(0.5, 0.6), vec2f(1.0, 0.05));
        hLine3 = drawShape(st, vec2f(0.6, 0.1), vec2f(0.8, 0.05));
        vLine1 = drawShape(st, vec2f(vLine1_xPos, 0.8), vec2f(0.025, 0.4));
        vLine2 = drawShape(st, vec2f(vLine2_xPos, 0.5), vec2f(0.025, 1.0));
        vLine3 = drawShape(st, vec2f(vLine3_xPos, 0.5), vec2f(0.025, 1.0));
        vLine4 = drawShape(st, vec2f(0.95, 0.5), vec2f(0.025, 1.0));
    } else if (t < 114.67) {
	// Phase 9: 94.17 - 114.67
	// vLine4 starts moving right 
        hLine1 = drawShape(st, vec2f(0.5, 0.8), vec2f(1.0, 0.05));
        hLine2 = drawShape(st, vec2f(0.5, 0.6), vec2f(1.0, 0.05));
        hLine3 = drawShape(st, vec2f(0.6, 0.1), vec2f(0.8, 0.05));
        vLine1 = drawShape(st, vec2f(vLine1_xPos, 0.8), vec2f(0.025, 0.4));
        vLine2 = drawShape(st, vec2f(vLine2_xPos, 0.5), vec2f(0.025, 1.0));
        vLine3 = drawShape(st, vec2f(vLine3_xPos, 0.5), vec2f(0.025, 1.0));
        vLine4 = drawShape(st, vec2f(vLine4_xPos, 0.5), vec2f(0.025, 1.0));
    } else if (t < 128.67) {
	// Phase 10: 114.67 - 128.67
	// hLines starts moving down 
        hLine1 = drawShape(st, vec2f(0.5, hLine1_yPos2), vec2f(1.0, 0.05));
        hLine2 = drawShape(st, vec2f(0.5, hLine2_yPos2), vec2f(1.0, 0.05));
        hLine3 = drawShape(st, vec2f(0.6, hLine3_yPos2), vec2f(0.8, 0.05));
        vLine1 = drawShape(st, vec2f(vLine1_xPos, 0.8), vec2f(0.025, 0.4));
        vLine2 = drawShape(st, vec2f(vLine2_xPos, 0.5), vec2f(0.025, 1.0));
        vLine3 = drawShape(st, vec2f(vLine3_xPos, 0.5), vec2f(0.025, 1.0));
        vLine4 = drawShape(st, vec2f(vLine4_xPos, 0.5), vec2f(0.025, 1.0));
    } else if (t < 142.67) {
	// Phase 11: 128.67 - 142.67
	// Phase: vLines starts moving left 
        hLine1 = drawShape(st, vec2f(0.5, hLine1_yPos2), vec2f(1.0, 0.05));
        hLine2 = drawShape(st, vec2f(0.5, hLine2_yPos2), vec2f(1.0, 0.05));
        hLine3 = drawShape(st, vec2f(0.6, hLine3_yPos2), vec2f(0.8, 0.05));
        vLine1 = drawShape(st, vec2f(vLine1_xPos2, 0.8), vec2f(0.025, 0.4));
        vLine2 = drawShape(st, vec2f(vLine2_xPos2, 0.5), vec2f(0.025, 1.0));
        vLine3 = drawShape(st, vec2f(vLine3_xPos2, 0.5), vec2f(0.025, 1.0));
        vLine4 = drawShape(st, vec2f(vLine4_xPos2, 0.5), vec2f(0.025, 1.0));
    } else if (t < 156.67) {
	// Phase 12: 142.67 - 156.67
	// vLines stop, hLines starts bouncing back and forth 
				hLine1 = drawShape(st, vec2f(0.5, hLine1_yPos3), vec2f(1.0, 0.05));
        hLine2 = drawShape(st, vec2f(0.5, hLine2_yPos3), vec2f(1.0, 0.05));
        hLine3 = drawShape(st, vec2f(0.6, hLine3_yPos3), vec2f(0.8, 0.05));
				vLine1 = drawShape(st, vec2f(0.05, 0.8), vec2f(0.025, 0.4));
        vLine2 = drawShape(st, vec2f(0.2, 0.5), vec2f(0.025, 1.0));
        vLine3 = drawShape(st, vec2f(0.7, 0.5), vec2f(0.025, 1.0));
        vLine4 = drawShape(st, vec2f(0.95, 0.5), vec2f(0.025, 1.0)); 
    } else if (t < 170.67) {
			// Phase 13: 156.67 - 170.67
			// vLines starts bouncing 
				hLine1 = drawShape(st, vec2f(0.5, hLine1_yPos3), vec2f(1.0, 0.05));
        hLine2 = drawShape(st, vec2f(0.5, hLine2_yPos3), vec2f(1.0, 0.05));
        hLine3 = drawShape(st, vec2f(0.6, hLine3_yPos3), vec2f(0.8, 0.05));
				vLine1 = drawShape(st, vec2f(vLine1_xPos3 , 0.8), vec2f(0.025, 0.4));
        vLine2 = drawShape(st, vec2f(vLine2_xPos3 , 0.5), vec2f(0.025, 1.0));
        vLine3 = drawShape(st, vec2f(vLine3_xPos3 , 0.5), vec2f(0.025, 1.0));
        vLine4 = drawShape(st, vec2f(vLine4_xPos3 , 0.5), vec2f(0.025, 1.0));
		} else if (t < 184.67) {
			// Phase 14: 170.67 - 184.67
			// Spinning clockwise around the center
			  hLine1 = drawShape(st_rot, vec2f(0.5, 0.8), vec2f(1.0, 0.05));
        hLine2 = drawShape(st_rot, vec2f(0.5, 0.6), vec2f(1.0, 0.05));
        hLine3 = drawShape(st_rot, vec2f(0.6, 0.1), vec2f(0.8, 0.05));
        vLine1 = drawShape(st_rot, vec2f(0.05, 0.8), vec2f(0.025, 0.4));
        vLine2 = drawShape(st_rot, vec2f(0.2, 0.5), vec2f(0.025, 1.0));
        vLine3 = drawShape(st_rot, vec2f(0.7, 0.5), vec2f(0.025, 1.0));
        vLine4 = drawShape(st_rot, vec2f(0.95, 0.5), vec2f(0.025, 1.0));
		} else {
				// Phase 15: 184.67 - ...
				// Random spins
				hLine1 = drawShape(st_rot2, vec2f(0.5, 0.8), vec2f(1.0, 0.05));
        hLine2 = drawShape(st_rot, vec2f(0.5, 0.6), vec2f(1.0, 0.05));
        hLine3 = drawShape(st_rot2, vec2f(0.6, 0.1), vec2f(0.8, 0.05));
        vLine1 = drawShape(st_rot, vec2f(0.05, 0.8), vec2f(0.025, 0.4));
        vLine2 = drawShape(st_rot2, vec2f(0.2, 0.5), vec2f(0.025, 1.0));
        vLine3 = drawShape(st_rot2, vec2f(0.7, 0.5), vec2f(0.025, 1.0));
        vLine4 = drawShape(st_rot, vec2f(0.95, 0.5), vec2f(0.025, 1.0));
		}

    // Colored rectangles 
    let rect1 = drawShape(st, vec2f(0.1, 0.8), vec2f(0.2, 0.4));
    color = mix(color, red, rect1);
    let rect2 = drawShape(st, vec2f(0.98, 0.8), vec2f(0.05, 0.4));
    color = mix(color, yellow, rect2);
    let rect3 = drawShape(st, vec2f(0.85, 0.05), vec2f(0.3, 0.1));
    color = mix(color, blue, rect3);

    // Determine if the pixel is in any shape 
    let allLineMask = hLine1 + hLine2 + hLine3 + vLine1 + vLine2 + vLine3 + vLine4; 
    let finalMask = min(1.0, allLineMask);

    // Draw the lines on top of the rectangles
    color = color * (1.0 - finalMask);
    return color;
}