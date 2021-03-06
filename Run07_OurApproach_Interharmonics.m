
clc
clear
fontSize = 10;
format long

t_sample = 0.13;
f0 = 50;
w0 = 2*pi*f0;

N = 20;
tf = 0.5;
nFilter = 30;
f1 = 20;
f2 = 90;
for subplotItr=1:3


    switch subplotItr
        case 1
            FInt1 = [45];
        case 2
            %FInt1 = [35, 40, 45, 55, 60, 65];
            FInt1_below = 2.5:2.5:47.5;
            FInt1_above = 52.5:2.5:97.5;
%              FInt1_below = 45:2.5:47.5;
%              FInt1_above = 52.5:10:400;
            FInt1 = cat(2, FInt1_below, FInt1_above);
        case 3
            FInt1 = [45];
            HInt1Coeff = [1:0.25:10]/100;
    end




    if (subplotItr==3)
        [row, col] = size(HInt1Coeff);
        Iteration = col;
    else
        [row, col] = size(FInt1);
        Iteration = col;
    end

    for itr=1:Iteration
        h3Coeff = 0;%0.20;
        h5Coeff = 0;%0.10;

        % interharmonics
        if(subplotItr==3)
            hInt1Coeff = HInt1Coeff(itr);
            hInt2Coeff = 0;
        else
            hInt1Coeff = 0.01;%0.05;
            hInt2Coeff = 0;
        end

        % do not change the sigma, this is the noise-free
        % version
        % for noise-case refer to Run01-OurApproaches_Noise
        sigma = 0;

        fs = N*f0;

        % the following coefficents are used in the arccosine-free version of the
        % algorithm
        a = fs/4/pi/sin(2*pi/N);
        b = 2*cos(2*pi/N);


        dt = 1/fs;

        %% filter
        fnyq = fs/2;


        w1 = f1/fnyq;
        w2 = f2/fnyq;

        filterCoeffs = fir1(nFilter, [w1 w2]);

        %%



        Am = 1*sqrt(2);



        t = 0:dt:tf;
        [row, col] = size(t);
        Nsamples = col;

        f = f0 *ones(size(t))+ sin(2*pi*1*t) +0.5*sin(2*pi*6*t);
        %f = 52 *ones(size(t));
        %f = f0 *ones(size(t))+25*t-25*t.^2;
        f3 = 3*f;
        f5 = 5*f;

        if(subplotItr==2)
            fInt1 = FInt1(itr)*ones(size(f));
            fInt2 = 49*ones(size(f));
        else
            fInt1 = FInt1(1)*ones(size(f));
            fInt2 = 49*ones(size(f));
        end

        f_max = max(f);
        f_min = min(f);

        w = 2*pi*f;

        w3 = 2*pi*f3;
        w5 = 2*pi*f5;

        wInt1 = 2*pi*fInt1;
        wInt2 = 2*pi*fInt2;




        phi0 = 0;

        theta1(1) = phi0;
        theta3(1) = phi0;
        theta5(1) = phi0;
        thetaInt1(1) = phi0;
        thetaInt2(1) = phi0;

        thetb1(1) = phi0+4*pi/3;
        thetb3(1) = phi0+4*pi/3;
        thetb5(1) = phi0+4*pi/3;
        thetbInt1(1) = phi0+4*pi/3;
        thetbInt2(1) = phi0+4*pi/3;

        thetc1(1) = phi0+2*pi/3;
        thetc3(1) = phi0+2*pi/3;
        thetc5(1) = phi0+2*pi/3;
        thetcInt1(1) = phi0+2*pi/3;
        thetcInt2(1) = phi0+2*pi/3;


        for k=2:length(t)
            theta1(k) = theta1(k-1)+w(k)*dt;
            theta3(k) = theta3(k-1)+w3(k)*dt;
            theta5(k) = theta5(k-1)+w5(k)*dt;
            thetaInt1(k) = thetaInt1(k-1)+wInt1(k)*dt;
            thetaInt2(k) = thetaInt2(k-1)+wInt2(k)*dt;


            thetb1(k) = thetb1(k-1)+w(k)*dt;
            thetb3(k) = thetb3(k-1)+w3(k)*dt;
            thetb5(k) = thetb5(k-1)+w5(k)*dt;
            thetbInt1(k) = thetbInt1(k-1)+wInt1(k)*dt;
            thetbInt2(k) = thetbInt2(k-1)+wInt2(k)*dt;

            thetc1(k) = thetc1(k-1)+w(k)*dt;
            thetc3(k) = thetc3(k-1)+w3(k)*dt;
            thetc5(k) = thetc5(k-1)+w5(k)*dt;
            thetcInt1(k) = thetcInt1(k-1)+wInt1(k)*dt;
            thetcInt2(k) = thetcInt2(k-1)+wInt2(k)*dt;
        end



        x = Am*cos(theta1);% + sigma*randn(size(t))+ h3Coeff*Am*cos(theta3)+ h5Coeff*Am*cos(theta5);
        y = Am*cos(thetb1);% + sigma*randn(size(t))+ h3Coeff*Am*cos(thetb3)+ h5Coeff*Am*cos(thetb5);
        z = Am*cos(thetc1);% + sigma*randn(size(t))+ h3Coeff*Am*cos(thetc3)+ h5Coeff*Am*cos(thetc5);



        %xh: x with harmonics
        %yh: y with harmonics
        %zh: z with harmonics
        xh = Am*cos(theta1) + sigma*randn(size(t))+ h3Coeff*Am*cos(theta3)+ h5Coeff*Am*cos(theta5)...
            +hInt1Coeff*Am*cos(thetaInt1)+hInt2Coeff*Am*cos(thetaInt2);
        yh = Am*cos(thetb1) + sigma*randn(size(t))+ h3Coeff*Am*cos(thetb3)+ h5Coeff*Am*cos(thetb5)...
            +hInt1Coeff*Am*cos(thetbInt1)+hInt2Coeff*Am*cos(thetbInt2);
        zh = Am*cos(thetc1) + sigma*randn(size(t))+ h3Coeff*Am*cos(thetc3)+ h5Coeff*Am*cos(thetc5)...
            +hInt1Coeff*Am*cos(thetcInt1)+hInt2Coeff*Am*cos(thetcInt2);

        % xhf: xh filtered
        % yhf: yh filtered
        % zhf: zh filtered
        xhf = filter(filterCoeffs,1,xh);
        yhf = filter(filterCoeffs,1,yh);
        zhf = filter(filterCoeffs,1,zh);



        %% our approach for window length of 9

        M = 3;
        windowLength = 2*M+3; % = 9
        K = M; % K = (windowLength-3)/2

        firstIndex = K+2;

        for k=firstIndex:Nsamples-K-1
            Xk = x(k-K:k+K)';
            Xk_minus = x(k-K-1:k+K-1)';
            Xk_plus = x(k-K+1:k+K+1)';
            f_hatWin9(k) = fs/2/pi*acos(Xk'*(Xk_minus+Xk_plus)/2/(Xk'*Xk));
            f_hatWin9_arccosinefree(k) = f0 + a*(Xk'*(b*Xk-Xk_minus-Xk_plus))/(Xk'*Xk);

            Yk = y(k-K:k+K)';
            Yk_minus = y(k-K-1:k+K-1)';
            Yk_plus = y(k-K+1:k+K+1)';

            Zk = z(k-K:k+K)';
            Zk_minus = z(k-K-1:k+K-1)';
            Zk_plus = z(k-K+1:k+K+1)';


            numArg = Xk'*(Xk_minus+Xk_plus);
            numArg = numArg + Yk'*(Yk_minus+Yk_plus);
            numArg = numArg + Zk'*(Zk_minus+Zk_plus);

            denArg = 2*(Xk'*Xk);
            denArg = denArg + 2*(Yk'*Yk);
            denArg = denArg + 2*(Zk'*Zk);

            arg = numArg/denArg;
            f_hatWin9_3phase(k) = fs/2/pi*acos(arg);

            % Antonio Lopez Algorithm
            Xk = [x(k-3); x(k); x(k+3)];
            Xk_minus = [x(k-4); x(k-1); x(k+2)];
            Xk_plus = [x(k-2); x(k+1); x(k+4)];
            f_hat_lopez(k) = fs/2/pi*acos(Xk'*(Xk_minus+Xk_plus)/2/(Xk'*Xk));
        end

        [r, c] = size(t);
        Nsamples = c;

        Kmax =6;

        f_hat_1phase = f0*ones(Kmax+1,Kmax+1+nFilter);
        f_hat_3phase = f0*ones(Kmax+1,Kmax+1+nFilter);

        f_hat_1phase_withHarmonics = f0*ones(Kmax+1,Kmax+1+nFilter);
        f_hat_3phase_withHarmonics = f0*ones(Kmax+1,Kmax+1+nFilter);

        f_hat_1phase_withHarmonics_filtered = f0*ones(Kmax+1,Kmax+1+nFilter);
        f_hat_3phase_withHarmonics_filtered = f0*ones(Kmax+1,Kmax+1+nFilter);

        for K = 0:Kmax
            % K = 0,           Window Length = 3
            % K = 1,           Window Length = 5
            % K = 2,           Window Length = 7
            % K = 3,           Window Length = 9
            % K = 4,           Window Length = 11
            lengthWindow(K+1)  = 2*K+3;
            firstIndex = K+2+nFilter;% the first element of Xk_minus must be available: it must be the first element of the signal
            % k-K-1 = 1  ==>  k=K+2
            lastIndex = Nsamples-K-1;% the last element of Xk_plus must be available: it must be the first element of the signal
            % k+K+1 = Nsamples  ==> k = Nsamples-K-1
            for k=firstIndex:lastIndex
                Xk = x(k-K:k+K)';
                Xk_minus = x(k-K-1:k+K-1)';
                Xk_plus = x(k-K+1:k+K+1)';
                arg = Xk'*(Xk_minus+Xk_plus)/2/(Xk'*Xk);
                if(abs(arg)>1)
                    f_hat_1phase(K+1,k) = f_hat_1phase(K+1,k-1);
                else
                    f_hat_1phase(K+1,k) = fs/2/pi*acos(arg);
                end
                f_hat_1phase_arccosinefree(K+1,k) = f0 + a*(Xk'*(b*Xk-Xk_minus-Xk_plus))/(Xk'*Xk);

                Xkh = xh(k-K:k+K)';
                Xkh_minus = xh(k-K-1:k+K-1)';
                Xkh_plus = xh(k-K+1:k+K+1)';
                arg = Xkh'*(Xkh_minus+Xkh_plus)/2/(Xkh'*Xkh);
                if(abs(arg)>1)
                    f_hat_1phase_withHarmonics(K+1,k) = f_hat_1phase_withHarmonics(K+1,k-1);
                else
                    f_hat_1phase_withHarmonics(K+1,k) = fs/2/pi*acos(arg);
                end
                f_hat_1phase_arccosinefree_withHarmonics(K+1,k) = f0 + a*(Xkh'*(b*Xkh-Xkh_minus-Xkh_plus))/(Xkh'*Xkh);

                Xkhf = xhf(k-K:k+K)';
                Xkhf_minus = xhf(k-K-1:k+K-1)';
                Xkhf_plus = xhf(k-K+1:k+K+1)';
                arg = Xkhf'*(Xkhf_minus+Xkhf_plus)/2/(Xkhf'*Xkhf);
                if(abs(arg)>1)
                    f_hat_1phase_withHarmonics_filtered(K+1,k) = f_hat_1phase_withHarmonics_filtered(K+1,k-1);
                else
                    f_hat_1phase_withHarmonics_filtered(K+1,k) = fs/2/pi*acos(arg);
                end
                f_hat_1phase_arccosinefree_withHarmonics_filtered(K+1,k) = f0 + a*(Xkhf'*(b*Xkhf-Xkhf_minus-Xkhf_plus))/(Xkhf'*Xkhf);


                Yk = y(k-K:k+K)';
                Yk_minus = y(k-K-1:k+K-1)';
                Yk_plus = y(k-K+1:k+K+1)';

                Zk = z(k-K:k+K)';
                Zk_minus = z(k-K-1:k+K-1)';
                Zk_plus = z(k-K+1:k+K+1)';


                numArg = Xk'*(Xk_minus+Xk_plus);
                numArg = numArg + Yk'*(Yk_minus+Yk_plus);
                numArg = numArg + Zk'*(Zk_minus+Zk_plus);

                denArg = 2*(Xk'*Xk);
                denArg = denArg + 2*(Yk'*Yk);
                denArg = denArg + 2*(Zk'*Zk);

                arg = numArg/denArg;
                if(abs(arg)>1)
                    f_hat_3phase(K+1,k) = f_hat_3phase(K+1,k-1);
                else
                    f_hat_3phase(K+1,k) = fs/2/pi*acos(arg);
                end

                % three-phase arccosine-free
                num = a*(Xk'*(b*Xk-Xk_minus-Xk_plus));
                num = num + a*(Yk'*(b*Yk-Yk_minus-Yk_plus));
                num = num + a*(Zk'*(b*Zk-Zk_minus-Zk_plus));

                den = (Xk'*Xk);
                den = den + (Yk'*Yk);
                den = den + (Zk'*Zk);

                f_hat_3phase_arccosinefree(K+1,k) = f0 + num/den;

                % three-phase with harmonics
                Ykh = yh(k-K:k+K)';
                Ykh_minus = yh(k-K-1:k+K-1)';
                Ykh_plus = yh(k-K+1:k+K+1)';

                Zkh = zh(k-K:k+K)';
                Zkh_minus = zh(k-K-1:k+K-1)';
                Zkh_plus = zh(k-K+1:k+K+1)';


                numArg = Xkh'*(Xkh_minus+Xkh_plus);
                numArg = numArg + Ykh'*(Ykh_minus+Ykh_plus);
                numArg = numArg + Zkh'*(Zkh_minus+Zkh_plus);

                denArg = 2*(Xkh'*Xkh);
                denArg = denArg + 2*(Ykh'*Ykh);
                denArg = denArg + 2*(Zkh'*Zkh);

                arg = numArg/denArg;
                if(abs(arg)>1)
                    f_hat_3phase_withHarmonics(K+1,k) = f_hat_3phase_withHarmonics(K+1,k-1);
                else
                    f_hat_3phase_withHarmonics(K+1,k) = fs/2/pi*acos(arg);
                end

                % three-phase with harmonics arccosine-free
                num = a*(Xkh'*(b*Xkh-Xkh_minus-Xkh_plus));
                num = num + a*(Ykh'*(b*Ykh-Ykh_minus-Ykh_plus));
                num = num + a*(Zkh'*(b*Zkh-Zkh_minus-Zkh_plus));

                den = (Xkh'*Xkh);
                den = den + (Ykh'*Ykh);
                den = den + (Zkh'*Zkh);

                f_hat_3phase_arccosinefree_withHarmonics(K+1,k) = f0 + num/den;


                % three-phase with harmonics,  Filtered
                Ykhf = yhf(k-K:k+K)';
                Ykhf_minus = yhf(k-K-1:k+K-1)';
                Ykhf_plus = yhf(k-K+1:k+K+1)';

                Zkhf = zhf(k-K:k+K)';
                Zkhf_minus = zhf(k-K-1:k+K-1)';
                Zkhf_plus = zhf(k-K+1:k+K+1)';


                numArg = Xkhf'*(Xkhf_minus+Xkhf_plus);
                numArg = numArg + Ykhf'*(Ykhf_minus+Ykhf_plus);
                numArg = numArg + Zkhf'*(Zkhf_minus+Zkhf_plus);

                denArg = 2*(Xkhf'*Xkhf);
                denArg = denArg + 2*(Ykhf'*Ykhf);
                denArg = denArg + 2*(Zkhf'*Zkhf);

                arg = numArg/denArg;
                if(abs(arg)>1)
                    f_hat_3phase_withHarmonics_filtered(K+1,k) = f_hat_3phase_withHarmonics_filtered(K+1,k-1);
                else
                    f_hat_3phase_withHarmonics_filtered(K+1,k) = fs/2/pi*acos(arg);
                end

                % three-phase with harmonics arccosine-free, filtered
                num = a*(Xkhf'*(b*Xkhf-Xkhf_minus-Xkhf_plus));
                num = num + a*(Ykhf'*(b*Ykhf-Ykhf_minus-Ykhf_plus));
                num = num + a*(Zkhf'*(b*Zkhf-Zkhf_minus-Zkhf_plus));

                den = (Xkhf'*Xkhf);
                den = den + (Ykhf'*Ykhf);
                den = den + (Zkhf'*Zkhf);

                f_hat_3phase_arccosinefree_withHarmonics_filtered(K+1,k) = f0 + num/den;


            end
            %     figure()
            %     plot(t(firstIndex:lastIndex), f(firstIndex:lastIndex),'Color','black','LineWidth',1)
            %     hold on
            %     plot(t(firstIndex:lastIndex), f_hat_1phase(K+1,firstIndex:lastIndex),'--','Color','blue','LineWidth',1)
            %     plot(t(firstIndex:lastIndex), f_hat_1phase_arccosinefree(K+1,firstIndex:lastIndex),'--','Color','green','LineWidth',1)
            %     plot(t(firstIndex:lastIndex), f_hat_3phase(K+1,firstIndex:lastIndex),'--','Color','red','LineWidth',1)
            %     plot(t(firstIndex:lastIndex), f_hat_3phase_arccosinefree(K+1,firstIndex:lastIndex),'--','Color','cyan','LineWidth',1)
            %     xlabel('time (sec)','FontSize', fontSize, 'FontWeight', 'bold')
            %     ylabel('f(t) and f_e_s_t(t))','FontSize', fontSize, 'FontWeight', 'bold')
            %     title(['data window length = ' int2str(2*K+3)],'FontSize', fontSize, 'FontWeight', 'bold')
            %     legend('exact frequency','estimated frequency')
            %     axis([0, tf, f_min-3, f_max+3])


            % with harmonics and/or noise
            se_1phase_withHarmonics = (f(firstIndex:lastIndex)-f_hat_1phase_withHarmonics(K+1,firstIndex:lastIndex)).^2;
            maxSE_1phase_withHarmonics = max(se_1phase_withHarmonics);
            MSE_1phase_withHarmonics(K+1) = mean(se_1phase_withHarmonics);
            MSE_1phase3phase_withHarmonics(K+1,1) = mean(se_1phase_withHarmonics);


            se_1phase_arccosinefree_withHarmonics = (f(firstIndex:lastIndex)-f_hat_1phase_arccosinefree_withHarmonics(K+1,firstIndex:lastIndex)).^2;
            maxSE_1phase_arccosinefree_withHarmonics = max(se_1phase_arccosinefree_withHarmonics);
            MSE_1phase_arccosinefree_withHarmonics(K+1) = mean(se_1phase_arccosinefree_withHarmonics);
            MSE_1phase3phase_withHarmonics(K+1,2) = mean(se_1phase_arccosinefree_withHarmonics);


            se_3phase_withHarmonics = (f(firstIndex:lastIndex)-f_hat_3phase_withHarmonics(K+1,firstIndex:lastIndex)).^2;
            maxSE_3phase_withHarmonics = max(se_3phase_withHarmonics);
            MSE_3phase_withHarmonics(K+1) = mean(se_3phase_withHarmonics);
            MSE_1phase3phase_withHarmonics(K+1,3) = mean(se_3phase_withHarmonics);


            se_3phase_arccosinefree_withHarmonics = (f(firstIndex:lastIndex)-f_hat_3phase_arccosinefree_withHarmonics(K+1,firstIndex:lastIndex)).^2;
            maxSE_3phase_arccosinefree_withHarmonics = max(se_3phase_arccosinefree_withHarmonics);
            MSE_3phase_arccosinefree_withHarmonics(K+1) = mean(se_3phase_arccosinefree_withHarmonics);
            MSE_1phase3phase_withHarmonics(K+1,4) = mean(se_3phase_arccosinefree_withHarmonics);

            % filtered
            se_1phase_withHarmonics_filtered = (f(firstIndex:lastIndex-nFilter/2)-f_hat_1phase_withHarmonics_filtered(K+1,firstIndex+nFilter/2:lastIndex)).^2;
            maxSE_1phase_withHarmonics_filtered = max(se_1phase_withHarmonics_filtered);
            MSE_1phase_withHarmonics_filtered(K+1) = mean(se_1phase_withHarmonics_filtered);
            MSE_1phase3phase_withHarmonics_filtered(K+1,1) = mean(se_1phase_withHarmonics_filtered);

            se_1phase_arccosinefree_withHarmonics_filtered = (f(firstIndex:lastIndex-nFilter/2)-f_hat_1phase_arccosinefree_withHarmonics_filtered(K+1,firstIndex+nFilter/2:lastIndex)).^2;
            maxSE_1phase_arccosinefree_withHarmonics_filtered = max(se_1phase_arccosinefree_withHarmonics_filtered);
            MSE_1phase_arccosinefree_withHarmonics_filtered(K+1) = mean(se_1phase_arccosinefree_withHarmonics_filtered);
            MSE_1phase3phase_withHarmonics_filtered(K+1,2) = mean(se_1phase_arccosinefree_withHarmonics_filtered);


            se_3phase_withHarmonics_filtered = (f(firstIndex:lastIndex-nFilter/2)-f_hat_3phase_withHarmonics_filtered(K+1,firstIndex+nFilter/2:lastIndex)).^2;
            maxSE_3phase_withHarmonics_filtered = max(se_3phase_withHarmonics_filtered);
            MSE_3phase_withHarmonics_filtered(K+1) = mean(se_3phase_withHarmonics_filtered);
            MSE_1phase3phase_withHarmonics_filtered(K+1,3) = mean(se_3phase_withHarmonics_filtered);

            se_3phase_arccosinefree_withHarmonics_filtered = (f(firstIndex:lastIndex-nFilter/2)-f_hat_3phase_arccosinefree_withHarmonics_filtered(K+1,firstIndex+nFilter/2:lastIndex)).^2;
            maxSE_3phase_arccosinefree_withHarmonics_filtered = max(se_3phase_arccosinefree_withHarmonics_filtered);
            MSE_3phase_arccosinefree_withHarmonics_filtered(K+1) = mean(se_3phase_arccosinefree_withHarmonics_filtered);
            MSE_1phase3phase_withHarmonics_filtered(K+1,4) = mean(se_3phase_arccosinefree_withHarmonics_filtered);


            %      figure()
            %      plot(t(firstIndex:lastIndex),mse,'Color','black','LineWidth',1)
            %      xlabel('time (sec)','FontSize', fontSize, 'FontWeight', 'bold')
            %      ylabel('MSE(f-f_e_s_t)','FontSize', fontSize, 'FontWeight', 'bold')
            %      title(['data window length = ' int2str(2*K+3)],'FontSize', fontSize, 'FontWeight', 'bold')
            %      axis([0, tf, 0, maxSE])
        end

        switch subplotItr
            case 1
                % for 1-phase case, the wibdow of length 3 is completely inefficent
                % therefore we ignore showing their MSE
                MSE_1phase3phase_withHarmonics(1,1)=0;
                MSE_1phase3phase_withHarmonics(1,2)=0;
            case 2
                %                 MSE_1Phase_WithInterhamonics_Win9(1, itr) = MSE_1phase3phase_withHarmonics(4,1);
                %                 MSE_1Phase_arccosinefree_WithInterhamonics_Win9(1, itr) = MSE_1phase3phase_withHarmonics(4,2);
                %                 MSE_3Phase_WithInterhamonics_Win9(1, itr) = MSE_1phase3phase_withHarmonics(4,3);
                %                 MSE_3Phase_arccosinefree_WithInterhamonics_Win9(1, itr) = MSE_1phase3phase_withHarmonics(4,4);

                MSE_1Phase3Phase_WithInterhamonics_Win9(itr,1) = MSE_1phase3phase_withHarmonics(4,1);
                MSE_1Phase3Phase_WithInterhamonics_Win9(itr,2) = MSE_1phase3phase_withHarmonics(4,2);
                MSE_1Phase3Phase_WithInterhamonics_Win9(itr,3) = MSE_1phase3phase_withHarmonics(4,3);
                MSE_1Phase3Phase_WithInterhamonics_Win9(itr,4) = MSE_1phase3phase_withHarmonics(4,4);
            case 3
                MSE_1Phase3Phase_WithInterhamonics_DifferentPercents_Win9(itr,1) = MSE_1phase3phase_withHarmonics(4,1);
                MSE_1Phase3Phase_WithInterhamonics_DifferentPercents_Win9(itr,2) = MSE_1phase3phase_withHarmonics(4,2);
                MSE_1Phase3Phase_WithInterhamonics_DifferentPercents_Win9(itr,3) = MSE_1phase3phase_withHarmonics(4,3);
                MSE_1Phase3Phase_WithInterhamonics_DifferentPercents_Win9(itr,4) = MSE_1phase3phase_withHarmonics(4,4);
        end



    end

    switch subplotItr
        case 1
            figure(1)
            subplot(311)
            bar(lengthWindow, MSE_1phase3phase_withHarmonics,'group')
            xlabel('length of data window','FontSize', fontSize, 'FontWeight', 'bold')
            ylabel('MSE','FontSize', fontSize, 'FontWeight', 'bold')
            legend('1-phase', '1-phase arccosine-free', '3-phase', '3-phase arccosine-free')
            title(['Fig. 9a: Comparison of four proposed approaches, with ' int2str(hInt1Coeff*100),'% of interharmonic of ', num2str(fInt1(1)), ' Hz'],'FontSize', fontSize, 'FontWeight', 'bold')
        case 2
            figure(1)
            subplot(313)
%            bar(FInt1, MSE_1Phase3Phase_WithInterhamonics_Win9,'group')
            bar(FInt1, MSE_1Phase3Phase_WithInterhamonics_Win9(:,1),'group')
            xlabel('interharmonic','FontSize', fontSize, 'FontWeight', 'bold')
            ylabel('MSE','FontSize', fontSize, 'FontWeight', 'bold')
            legend('1-phase  (window length of 9)', '1-phase arccosine-free', '3-phase', '3-phase arccosine-free')
            title(['Fig. 9c: Effct of different interharmonics, with ' int2str(hInt1Coeff*100),'% of amplitude ratio'],'FontSize', fontSize, 'FontWeight', 'bold')
        case 3
            figure(1)
            subplot(312)
            bar(HInt1Coeff*100, MSE_1Phase3Phase_WithInterhamonics_DifferentPercents_Win9(:,1),'group')
%            plot(HInt1Coeff*100, MSE_1Phase3Phase_WithInterhamonics_DifferentPercents_Win9(:,1),'Color','black','LineWidth',1.5)
%             hold on
%             plot(HInt1Coeff*100, MSE_1Phase3Phase_WithInterhamonics_DifferentPercents_Win9(:,1), '-.','Color','black','LineWidth',1.5)
            xlabel('ratio of interharmonic (%)','FontSize', fontSize, 'FontWeight', 'bold')
            ylabel('MSE','FontSize', fontSize, 'FontWeight', 'bold')
            legend('1-phase (window length of 9)', '1-phase arccosine-free')
            title(['Fig. 9b: Effect of different amounts of interharmonic (45 Hz)'],'FontSize', fontSize, 'FontWeight', 'bold')
            axis([0.5, 10.5, 0, 0.2])
    end



end


% % for 1-phase case, the wibdow of length 3 is completely inefficent
% % therefore we ignore showing their MSE
% MSE_1phase3phase_withHarmonics(1,1)=0;
% MSE_1phase3phase_withHarmonics(1,2)=0;
% figure(1)
% bar(lengthWindow, MSE_1phase3phase_withHarmonics,'group')
% xlabel('length of data window','FontSize', fontSize, 'FontWeight', 'bold')
% ylabel('mean(f-f_e_s_t)^2','FontSize', fontSize, 'FontWeight', 'bold')
% legend('1-phase', '1-phase arccosine-free', '3-phase', '3-phase arccosine-free')
% title(['Comparison of four proposed approaches, 3^r^d harmonic = ' int2str(h3Coeff*100),'%, 5^t^h harmonic = ' int2str(h5Coeff*100),'%'],'FontSize', fontSize, 'FontWeight', 'bold')
% %title(['Comparison of four proposed approaches, SNR = ' int2str(20*log10(1/sigma))],'FontSize', fontSize, 'FontWeight', 'bold')
%
% % for 1-phase case, the wibdow of length 3 is completely inefficent
% % therefore we ignore showing their MSE
% MSE_1phase3phase_withHarmonics_filtered(1,1)=0;
% MSE_1phase3phase_withHarmonics_filtered(1,2)=0;
% figure(2)
% bar(lengthWindow, MSE_1phase3phase_withHarmonics_filtered,'group')
% xlabel('length of data window','FontSize', fontSize, 'FontWeight', 'bold')
% ylabel('mean(f-f_e_s_t)^2','FontSize', fontSize, 'FontWeight', 'bold')
% legend('1-phase', '1-phase arccosine-free', '3-phase', '3-phase arccosine-free')
% title(['Comparison of four proposed approaches, 3^r^d harmonic = ' int2str(h3Coeff*100),'%, 5^t^h harmonic = ' int2str(h5Coeff*100),'%, signal pre-filtered'],'FontSize', fontSize, 'FontWeight', 'bold')
% %title(['Comparison of four proposed approaches, SNR = ' int2str(20*log10(1/sigma)) ', signal pre-filtered'],'FontSize', fontSize, 'FontWeight', 'bold')
%
% figure(3)
% plot(t(firstIndex:lastIndex), f(firstIndex:lastIndex),'Color','black','LineWidth',1)
% hold on
% %plot(t(firstIndex:lastIndex), f_hat_1phase(4, firstIndex:lastIndex), 'red')
% %plot(t(firstIndex:lastIndex), f_hat_1phase_withHarmonics_filtered(4,firstIndex:lastIndex), 'green')
% plot(t(firstIndex:lastIndex-nFilter/2), f_hat_1phase_withHarmonics_filtered(4,firstIndex+nFilter/2:lastIndex), '--', 'Color','black','LineWidth',1)
% xlabel('time (sec)','FontSize', fontSize, 'FontWeight', 'bold')
% ylabel('frequency (Hz)','FontSize', fontSize, 'FontWeight', 'bold')
% title('Comparison of exact and estimated frequency','FontSize', fontSize, 'FontWeight', 'bold')
% legend('exact frequency', 'estimated frequency')
%
% figure(4)
% subplot(211)
% bar(lengthWindow, MSE_1phase3phase_withHarmonics,'group')
% xlabel('length of data window','FontSize', fontSize, 'FontWeight', 'bold')
% ylabel('mean(f-f_e_s_t)^2','FontSize', fontSize, 'FontWeight', 'bold')
% legend('1-phase', '1-phase arccosine-free', '3-phase', '3-phase arccosine-free')
% title(['Comparison of four proposed approaches, 3^r^d harmonic = ' int2str(h3Coeff*100),'%, 5^t^h harmonic = ' int2str(h5Coeff*100),'%'],'FontSize', fontSize, 'FontWeight', 'bold')
%
% subplot(212)
% bar(lengthWindow, MSE_1phase3phase_withHarmonics_filtered,'group')
% xlabel('length of data window','FontSize', fontSize, 'FontWeight', 'bold')
% ylabel('mean(f-f_e_s_t)^2','FontSize', fontSize, 'FontWeight', 'bold')
% legend('1-phase', '1-phase arccosine-free', '3-phase', '3-phase arccosine-free')
% title(['Comparison of four proposed approaches, 3^r^d harmonic = ' int2str(h3Coeff*100),'%, 5^t^h harmonic = ' int2str(h5Coeff*100),'%, signal pre-filtered'],'FontSize', fontSize, 'FontWeight', 'bold')
%
