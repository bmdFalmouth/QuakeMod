// Raycast under crosshair; return first hit (entity or world)
entity(float range) pick_first_hit =
{
    local vector start, end;
    if (!range) range = 2048;

    makevectors(self.v_angle);
    start = self.origin + self.view_ofs;
    end   = start + v_forward * range;

    traceline(start, end, FALSE, self); // include monsters
    if (trace_fraction < 1)
        return trace_ent;
    return world;
};

void(entity hit) do_click_action =
{
    if (!hit || hit == world)
    {
        centerprint(self, "Nothing under crosshair.\n");
        self.selected = world;
        return;
    }

    // optional: only allow marked entities
    if (hit.is_selectable != 1)
    {
        centerprint(self, hit.classname);
        centerprint(self, "not selectable");
        self.selected = world;
        return;
    }

    self.selected = hit;

    if (hit.onclick)
        hit.onclick();  // per-entity handler
    else if (hit.use)
        hit.use();      // fallback to standard .use
    else{
        centerprint(self, hit.classname);
        centerprint(self, "selectable");
    }
};

// One-shot click (on press)
void() Cmd_ClickPress =
{
    local entity hit;
    self.mouse1_down = 1;
    hit = pick_first_hit(2048);
    do_click_action(hit);
};

// Release
void() Cmd_ClickRelease =
{
    self.mouse1_down = 0;
};
