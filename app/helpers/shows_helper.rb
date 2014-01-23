module ShowsHelper

  def bid_end? win
    return win.nil?||!(win[:activity_id] == @bidlist[:activity_id]&&win[:bid_name]== @bidlist[:name])
  end

  def bid_invalid? win1,win
    return win1 == 'true' && win[:name]=='竞价无效'
  end

  def bid_valid? win1,win
    return win1=='true'&&win[:name]!='竞价无效'
  end

  def bid_running? win,bidlist
    return win.nil?||!(win[:activity_id] == bidlist[:activity_id]&&win[:bid_name]== bidlist[:name])
  end
end
