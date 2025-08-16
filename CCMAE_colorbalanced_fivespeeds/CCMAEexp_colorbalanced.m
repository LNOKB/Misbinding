function CCMAEexp_colorbalanced
Subnum=input('Subject No:');

ListenChar(2);
AssertOpenGL;
KbName('UnifyKeyNames');
%手作りfunction
%myKeyCheck;



try

    Screen('Preference','SkipSyncTests',1);
    screenNumber=max(Screen('Screens'));

    customRect = [280, 221, 740, 546];%(740-280=460=)20deg*(540-215=325=)14deg ⇒　23pixel=1deg
    %%

    [w, rect]=Screen('OpenWindow', screenNumber, BlackIndex(screenNumber));%, customRect
    %w=10と出る
    % [center(1), center(2)] = RectCenter(rect);
    center(1) = 510;
    center(2) = 383;

    black = BlackIndex(w);
    white = WhiteIndex(w);
    screenWidth = customRect(3)-customRect(1); %rect(3);
    screenHeight = customRect(4)-customRect(2); %rect(4);
    %xmaxleft = screenWidth/5*2;
    xmaxcentral = screenWidth/10*8/2;
    xmaxleftright = screenWidth/10*1/2;
    ymax = screenHeight/2;

    %ドットの数
    numDots_ind = 1792/2;
    numDots_eff = 448/2/2;%red+green=448

    %ドットの大きさ(deg)
    dot_w       = 0.1;  % width of dot (deg)

    %ドットの速度(deg)
    dot_speed   = 3;    % dot speed (deg/sec)

    %固視点の大きさ(deg)
    % fix_r       = 0.15; % radius of fixation point (deg)

    %そのほかの設定
    mon_width   = 33;   % horizontal dimension of viewable screen (cm):EIZO EV2795
    v_dist      = 57;   % viewing distance (cm)


    % Enable alpha blending with proper blend-function. We need it
    % for drawing of smoothed points:
    %ドットのアンチエイリアスのため
    Screen('BlendFunction', w, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    fps=Screen('FrameRate',w); %59:EV2795&DESKTOP      % frames per second
    ifi=Screen('GetFlipInterval', w);
    if fps==0
        fps=1/ifi;
    end


    % pixelsでの値
    ppd = 23;
    pfs = dot_speed * ppd / fps;
    dotSize = dot_w * ppd;
    % fix_cord = [center-fix_r*ppd center+fix_r*ppd];

    white = WhiteIndex(w);
    red = [230 60 0];
    green = [80 138 50];
    HideCursor; % Hide the mouse cursor
    Priority(MaxPriority(w));

    % Do initial flip...
    vbl=Screen('Flip', w);

    dotsA = [];
    dotsB = [];
    dotsC = [];
    dotsD = [];

    %dotsA(1, :) = 2 * xmaxleft * rand(1, numDots_ind) - xmaxleft;
    dotsA(1, :) = 2 * xmaxcentral * rand(1, numDots_ind) - xmaxcentral;
    dotsA(2, :) = 2 * ymax * rand(1, numDots_ind) - ymax;

    %dotsB(1, :) = 2 * xmaxleft * rand(1, numDots_ind) - xmaxleft;
    dotsB(1, :) = 2 * xmaxcentral * rand(1, numDots_ind) - xmaxcentral;
    dotsB(2, :) = 2 * ymax * rand(1, numDots_ind) - ymax;

    %dotsC(1, :) = 2 * xmaxleft * rand(1, numDots_eff) - xmaxleft;
    dotsC(1, :) = 2 * xmaxleftright * rand(1, numDots_eff) - xmaxleftright;
    dotsC(2, :) = 2 * ymax * rand(1, numDots_eff) - ymax;

    %dotsD(1, :) = 2 * xmaxleft * rand(1, numDots_eff) - xmaxleft;
    dotsD(1, :) = 2 * xmaxleftright * rand(1, numDots_eff) - xmaxleftright;
    dotsD(2, :) = 2 * ymax * rand(1, numDots_eff) - ymax;



    blockmat = repmat(1:4,1,5);
    %blockmat = repmat(1:4,1,1);
    blockorder = randperm(length(blockmat)); %20

    %fixation point
    d1 = 1.0; % diameter of outer circle (degrees)
    d2 = 0.1; % diameter of inner circle (degrees)

    for nowblock = 1:length(blockmat)

        nowblocktype = blockmat(blockorder(nowblock));
        if nowblocktype == 1 %induction+effect
            inductioncolormat = horzcat(red, green);%vertcat( [255; 0; 0], [0; 255; 0]);
            effectcolormat = horzcat(green,red);
            ind_up_color = 0;
        elseif nowblocktype == 2 %induction+effect
            inductioncolormat = horzcat(green,red);
            effectcolormat = horzcat(red, green); %induction: green↑ red↓ / effect: red↑ green↓
            ind_up_color = 1;
        elseif nowblocktype == 3 %induction
            inductioncolormat = horzcat(red, green);% red↑ green↓
            ind_up_color = 0;
        else
            inductioncolormat = horzcat(green,red);% green↑ red↓
            ind_up_color = 1;
        end

       trialmat = repmat([0  -0.6;
            0  -0.3;
            0   0;
            0   0.3;
            0   0.6;
            1  -0.6;
            1  -0.3;
            1   0;
            1   0.3;
            1   0.6], 4, 1); %4,1
        trialorder = randperm(length(trialmat)); %=40

        % ----------------------
        % topping-up adaptor(30s)
        % ----------------------
        for i = 1:1800

            Screen('FillOval', w, black, [center(1)-d1/2 * ppd, center(2)-d1/2 * ppd, center(1)+d1/2 * ppd, center(2)+d1/2 * ppd], d1 * ppd);
            Screen('DrawLine', w, white, center(1)-d1/2 * ppd, center(2), center(1)+d1/2 * ppd, center(2), min(d2 * ppd, 10));
            Screen('DrawLine',w, white, center(1), center(2)-d1/2 * ppd, center(1), center(2)+d1/2 * ppd, min(d2 * ppd, 10));
            Screen('FillOval', w, black, [center(1)-d2/2 * ppd, center(2)-d2/2 * ppd, center(1)+d2/2 * ppd, center(2)+d2/2 * ppd], d2 * ppd);

            height = customRect(2)+screenHeight/2;
            %StimulusA【induction↑】
            %Screen('DrawDots', w, dotsA, dotSize, inductioncolormat(1:3), [customRect(1)+screenWidth/5*2 height], 1);%induction part
            Screen('DrawDots', w, dotsA, dotSize, inductioncolormat(1:3), [customRect(1)+screenWidth/2*1 height], 1);%induction part

            %StimulusB【induction↓】
            %Screen('DrawDots', w, dotsB, dotSize, inductioncolormat(4:6), [customRect(1)+screenWidth/5*2 height], 1);%induction part
            Screen('DrawDots', w, dotsB, dotSize, inductioncolormat(4:6), [customRect(1)+screenWidth/2*1 height], 1);%induction part


            if (nowblocktype == 1) || (nowblocktype == 2)
                %StimulusC【effect↑】
                Screen('DrawDots', w, dotsC, dotSize, effectcolormat(1:3), [customRect(1)+screenWidth/20*19 height], 1);%effect part
                Screen('DrawDots', w, dotsC, dotSize, effectcolormat(1:3), [customRect(1)+screenWidth/20*1 height], 1);%effect part


                %StimulusD【effect↓】
                Screen('DrawDots', w, dotsD, dotSize, effectcolormat(4:6), [customRect(1)+screenWidth/20*19 height], 1);%effectpart
                Screen('DrawDots', w, dotsD, dotSize, effectcolormat(4:6), [customRect(1)+screenWidth/20*1 height], 1);%effectpart

            else
            end

            Screen('DrawingFinished', w); % Tell PTB that no further drawing commands will follow before Screen('Flip')

            %StimulusA【induction↑】
            dotsA(2, :) =dotsA(2, :) - pfs;
            goupA = find(dotsA(2,:) > ymax);
            godownA = find(dotsA(2,:) < -ymax);
            dotsA(2, goupA) = -ymax;
            dotsA(2, godownA) = ymax;

            %StimulusB【induction↓】
            dotsB(2, :) =dotsB(2, :) + pfs;
            goupB = find(dotsB(2,:) > ymax);
            godownB = find(dotsB(2,:) < -ymax);
            dotsB(2, goupB) = -ymax;
            dotsB(2, godownB) = ymax;

            if (nowblocktype == 1) || (nowblocktype == 2)
                %StimulusC【effect↑】
                dotsC(2, :) =dotsC(2, :) - pfs;
                goupC = find(dotsC(2,:) > ymax);
                godownC = find(dotsC(2,:) < -ymax);
                dotsC(2, goupC) = -ymax;
                dotsC(2, godownC) = ymax;

                %StimulusD【effect↓】
                dotsD(2, :) =dotsD(2, :) + pfs;
                goupD = find(dotsD(2,:) > ymax);
                godownD = find(dotsD(2,:) < -ymax);
                dotsD(2, goupD) = -ymax;
                dotsD(2, godownD) = ymax;
            else
            end

            Screen('Flip', w);
        end


        for nowtrial = 1:length(trialmat) %40

            nowtrial_testcolor = trialmat(trialorder(nowtrial),1);
            if nowtrial_testcolor == 0
                testcolor = red;
                test_color = 0;
            else
                testcolor = green;
                test_color = 1;
            end

            testspeed = trialmat(trialorder(nowtrial),2);

            % --------------
            % adaptor(5s)
            % -------------
            for i = 1:300

                Screen('FillOval', w, black, [center(1)-d1/2 * ppd, center(2)-d1/2 * ppd, center(1)+d1/2 * ppd, center(2)+d1/2 * ppd], d1 * ppd);
                Screen('DrawLine', w, white, center(1)-d1/2 * ppd, center(2), center(1)+d1/2 * ppd, center(2), min(d2 * ppd, 10));
                Screen('DrawLine',w, white, center(1), center(2)-d1/2 * ppd, center(1), center(2)+d1/2 * ppd, min(d2 * ppd, 10));
                Screen('FillOval', w, black, [center(1)-d2/2 * ppd, center(2)-d2/2 * ppd, center(1)+d2/2 * ppd, center(2)+d2/2 * ppd], d2 * ppd);

                %StimulusA【induction↑】
                %Screen('DrawDots', w, dotsA, dotSize, inductioncolormat(1:3), [customRect(1)+screenWidth/5*2 height], 1);%induction part
                Screen('DrawDots', w, dotsA, dotSize, inductioncolormat(1:3), [customRect(1)+screenWidth/2*1 height], 1);%induction part

                %StimulusB【induction↓】
                %Screen('DrawDots', w, dotsB, dotSize, inductioncolormat(4:6), [customRect(1)+screenWidth/5*2 height], 1);%induction part
                Screen('DrawDots', w, dotsB, dotSize, inductioncolormat(4:6), [customRect(1)+screenWidth/2*1 height], 1);%induction part


                if (nowblocktype == 1) || (nowblocktype == 2)
                    %StimulusC【effect↑】
                    Screen('DrawDots', w, dotsC, dotSize, effectcolormat(1:3), [customRect(1)+screenWidth/20*19 height], 1);%effect part
                    Screen('DrawDots', w, dotsC, dotSize, effectcolormat(1:3), [customRect(1)+screenWidth/20*1 height], 1);%effect part


                    %StimulusD【effect↓】
                    Screen('DrawDots', w, dotsD, dotSize, effectcolormat(4:6), [customRect(1)+screenWidth/20*19 height], 1);%effectpart
                    Screen('DrawDots', w, dotsD, dotSize, effectcolormat(4:6), [customRect(1)+screenWidth/20*1 height], 1);%effectpart

                else
                end

                Screen('DrawingFinished', w); % Tell PTB that no further drawing commands will follow before Screen('Flip')

                %StimulusA【induction↑】
                dotsA(2, :) =dotsA(2, :) - pfs;
                goupA = find(dotsA(2,:) > ymax);
                godownA = find(dotsA(2,:) < -ymax);
                dotsA(2, goupA) = -ymax;
                dotsA(2, godownA) = ymax;

                %StimulusB【induction↓】
                dotsB(2, :) =dotsB(2, :) + pfs;
                goupB = find(dotsB(2,:) > ymax);
                godownB = find(dotsB(2,:) < -ymax);
                dotsB(2, goupB) = -ymax;
                dotsB(2, godownB) = ymax;

                if (nowblocktype == 1) || (nowblocktype == 2)
                    %StimulusC【effect↑】
                    dotsC(2, :) =dotsC(2, :) - pfs;
                    goupC = find(dotsC(2,:) > ymax);
                    godownC = find(dotsC(2,:) < -ymax);
                    dotsC(2, goupC) = -ymax;
                    dotsC(2, godownC) = ymax;

                    %StimulusD【effect↓】
                    dotsD(2, :) =dotsD(2, :) + pfs;
                    goupD = find(dotsD(2,:) > ymax);
                    godownD = find(dotsD(2,:) < -ymax);
                    dotsD(2, goupD) = -ymax;
                    dotsD(2, godownD) = ymax;
                else
                end

                Screen('Flip', w);
            end

            % --------------
            % Blank(0.2s)
            % --------------
            Screen('FillOval', w, black, [center(1)-d1/2 * ppd, center(2)-d1/2 * ppd, center(1)+d1/2 * ppd, center(2)+d1/2 * ppd], d1 * ppd);
            Screen('DrawLine', w, white, center(1)-d1/2 * ppd, center(2), center(1)+d1/2 * ppd, center(2), d2 * ppd);
            Screen('DrawLine',w, white, center(1), center(2)-d1/2 * ppd, center(1), center(2)+d1/2 * ppd, d2 * ppd);
            Screen('FillOval', w, black, [center(1)-d2/2 * ppd, center(2)-d2/2 * ppd, center(1)+d2/2 * ppd, center(2)+d2/2 * ppd], d2 * ppd);

            Screen('Flip', w);
            WaitSecs(0.2);


            % --------------
            % Test(0.2s)
            % --------------
            leftorright = randi([0, 1]);
            for j = 1:12
                Screen('FillOval', w, black, [center(1)-d1/2 * ppd, center(2)-d1/2 * ppd, center(1)+d1/2 * ppd, center(2)+d1/2 * ppd], d1 * ppd);
                Screen('DrawLine', w, white, center(1)-d1/2 * ppd, center(2), center(1)+d1/2 * ppd, center(2), d2 * ppd);
                Screen('DrawLine',w, white, center(1), center(2)-d1/2 * ppd, center(1), center(2)+d1/2 * ppd, d2 * ppd);
                Screen('FillOval', w, black, [center(1)-d2/2 * ppd, center(2)-d2/2 * ppd, center(1)+d2/2 * ppd, center(2)+d2/2 * ppd], d2 * ppd);

                if leftorright == 0
                    Screen('DrawDots', w, dotsD, dotSize, testcolor, [customRect(1) + screenWidth/20*1 height], 1);%left
                else
                    Screen('DrawDots', w, dotsD, dotSize, testcolor, [customRect(1) + screenWidth/20*19 height], 1);%right
                end
               
                Screen('DrawingFinished', w); % Tell PTB that no further drawing commands will follow before Screen('Flip')


                %StimulusD【test】
                dotsD(2, :) =dotsD(2, :) + testspeed * ppd / fps;
                goupD = find(dotsD(2,:) > ymax);
                godownD = find(dotsD(2,:) < -ymax);
                dotsD(2, goupD) = -ymax;
                dotsD(2, godownD) = ymax;

                Screen('Flip', w);
            end



            % --------------
            % Response
            % --------------
            Screen('TextSize', w, 50);
            DrawFormattedText(w, 'UP / DOWN', 'center', 'center', white);
            Screen('Flip', w);

            startrt = GetSecs;


            while 1
                [keyIsDown, endrt, keyCode] = KbCheck;
                if keyIsDown
                    keyCode = find(keyCode, 1);
                    if (keyCode == KbName('UpArrow')) || (keyCode == KbName('DownArrow'))
                        if keyCode == KbName('UpArrow')
                            keypress=0;
                            break;
                        elseif keyCode == KbName('DownArrow')
                            keypress=1;
                            break;
                        else
                        end
                    end
                end
            end

            RT = round(endrt - startrt,5);

            if exist('CCMAEexp_colorbalanced.csv', 'file') ~= 2
                fid = fopen('CCMAEexp_colorbalanced.csv', 'wt');
                fprintf(fid, 'Subnum,nowblock,nowblocktype,nowtrial,ind_up_color,test_color,testspeed,leftorright,keypress,RT\n');
                fclose(fid);
            end

            fid = fopen('CCMAEexp_colorbalanced.csv','at');
            fprintf(fid, '%d,%d,%d,%d,%d,%d,%d,%d,%d,%2.3f\n',Subnum,nowblock,nowblocktype,nowtrial,ind_up_color,test_color,testspeed,leftorright,keypress,RT);
            fclose(fid);
        end

        % --------------
        % Rest
        % --------------
        endtext = sprintf('Block %d / %d Completed.\n\nPress any key to continue...', nowblock, length(blockmat));
        Screen('TextSize', w, 40);
        DrawFormattedText(w, endtext, 'center', 'center', white);
        Screen('Flip', w);
        WaitSecs(1);


        while 1
            [keyIsDown2, endrt2, keyCode2] = KbCheck;
            keyCode2 = find(keyCode2, 1);
            if keyIsDown2
                break;
            end
        end
        WaitSecs(1.5);

    end



    %終了処理
    Screen('CloseAll');
    ShowCursor;
    ListenChar(0);

catch
    Screen('CloseAll');
    ShowCursor;
    ListenChar(0);
end
