%SP +
rounds = 11;
src = '0x0A15598A';
x1 = hexToBinaryVector(src,32);
s = cell(8,1);
s{1} = '0xB52EDA801C93F764';s{2} = '0xB47538C29F0A1D6E';
s{3} = '0x7AF4690CB813D25E';s{4} = '0xA6ED342CB58071F9';
s{5} = '0xED0BF751924C8A63';s{6} = '0xD0EC7839F15A6B42';
s{7} = '0x7684FDE9ACB05132';s{8} = '0x7205AFE14639CBD8';
pt = [4 29 30 23 27 9 12 11 1 16 14 25 8 19 21 7 24 5 31 17 32 15 20 28 2 3 10 26 22 6 18 13];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  ROUND KEYs GENERATION   %  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
textKey = '0x0FE1A54D';
binaryKey = hexToBinaryVector(textKey,32);
keySet = cell(rounds,1);
keySet{1} = binaryKey;

for i = 2:rounds
    
%    keySet{i} = hexToBinaryVector(dec2hex(mod(7+sym(hex2dec(binaryVectorToHex(keySet{i-1})))^2,2^32)),32);
%     sM = zeros(1,15);
%     keySet{i} = zeros(1,32);
%     sM = keySet{i-1}(18:32);
%     
%     for j=1:32
%         if (j < 16)
%             keySet{i}(j) = sM(j);
%         else
%             keySet{i}(j) = keySet{i-1}(j-15);
%         end
%     end

    sM = zeros(1,11);
    keySet{i} = zeros(1,32);
    sM = keySet{i-1}(1:11);
    k = 1;
    
    for j=1:32
        if (j < 22)
            keySet{i}(j) = keySet{i-1}(j+11);
        else
            keySet{i}(j) = sM(k);
            k = k + 1;
        end
    end
%        if( mod(i,4) == mod(0,4) || mod(i,4) == mod(1,4)) 
%         keySet{i} = binaryKey(1:32); 
%     else 
%         keySet{i} = binaryKey(33:64); 
%     end


%keySet{i} = hexToBinaryVector(dec2hex(mod(11111+sym(hex2dec(binaryVectorToHex(keySet{i-1})))^3,2^32)),32);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        ENCRYPTION        %  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
text = x1;

for i = 1:rounds
   
    %display(binaryVectorToHex(text), 'text')
    %display(binaryVectorToHex(keySet{i}), 'key')    
    
   tmpT =  num2str(dec2hex(hex2dec(binaryVectorToHex(text))+ hex2dec(binaryVectorToHex(keySet{i}))));
    
   if(length(tmpT) > 8)
       tmpT(1) = [];
   end
   
  % display(tmpT, 'T+K');
    
    
    for j=1:length(tmpT)
        tmpT(j) = s{j}(hex2dec(tmpT(j))+1+2);
    end

   % display(tmpT, 'T S')
    
    tmpT = hexToBinaryVector(tmpT,32);
    % P - substitution
    temp = tmpT;
    for j=1:length(tmpT)
        tmpT(j) = temp(pt(j));
    end
    
  %  display(binaryVectorToHex(tmpT), 'T P')
    
    text =  tmpT;
     
end
encrypted(1:32) = text;      
binaryVectorToHex(encrypted)  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        DECRYPTION        %  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%text1 = encrypted;

text1 = x1;


for i = 1:rounds
    % SP -substitution for right block
    % S - substitution
    
   % tmpT = text1;
    
    temp = text1;
    for j=1:length(text1)
        text1(pt(j)) = temp(j);
    end
    
   % display(binaryVectorToHex(text1), 'T P')
    
    tmpT = num2str (binaryVectorToHex(text1));
    
    
    
    for j=1:length(tmpT)
        unitS = num2str(s{j});
       %tmpT(j)
        for k=3:length(unitS)
         %   s{j}(k)
            if(tmpT(j) == s{j}(k))
                
                tmpT(j) = num2str(dec2hex(k - 3));
                break
            end
        end
        %tmpT(j)
    end
   % tmpT
   % display(tmpT, 'T S')
     
    display(tmpT, 'text')
    display(binaryVectorToHex(keySet{rounds-i+1}), 'key')

    
    
    
    decDataTminusK = hex2dec(tmpT) - hex2dec(binaryVectorToHex(keySet{rounds-i+1}));
    
    if(decDataTminusK > 0)
        tmpT =  num2str(dec2hex(decDataTminusK))
    else
        dDataRplusKBin = input('dRightPlusKeySetBin = ');
        tmpT = num2str(binaryVectorToHex(dDataRplusKBin))
    end
    
    if(length(tmpT) > 8)
        tmpT(1) = [];
    end
   
    text1 = hexToBinaryVector(tmpT,32);
    
   
     
end
decrypted(1:32) = text1;      
binaryVectorToHex(decrypted)    


