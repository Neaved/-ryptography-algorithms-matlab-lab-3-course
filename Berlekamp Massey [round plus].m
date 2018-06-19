% Ëýé-Ìýññè +
rounds = 12;
src = '0x4A7449FE4B6FA096';
x1 = hexToBinaryVector(src,64);
s = cell(8,1);
s{1} = '0x8A031CE9F4B5276D';s{2} = '0xC2B45F97AE3D6108';
s{3} = '0xFEA5B08C139472D6';s{4} = '0xF5827D1604BAEC93';
s{5} = '0xD394F2C51B80A7E6';s{6} = '0x5B89FAED013C7426';
s{7} = '0x361AC508E9FD4B72';s{8} = '0x5E71D24FBA9C3608';
pt = [24 14 11 31 28 10 21 2 27 17 22 20 3 30 5 9 32 7 25 23 18 4 16 26 19 13 6 15 1 29 12 8];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  ROUND KEYs GENERATION   %  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
textKey = '0x42185C6B';
binaryKey = hexToBinaryVector(textKey,32);
keySet = cell(rounds,1);
keySet{1} = binaryKey;
%tmp = binaryVectorToHex(keySet{1});
for i = 2:rounds
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
%keySet{i} = hexToBinaryVector(dec2hex(mod(7+sym(hex2dec(binaryVectorToHex(keySet{i-1})))^2,2^32)),32);
    keySet{i} = hexToBinaryVector(dec2hex(mod(11111+sym(hex2dec(binaryVectorToHex(keySet{i-1})))^3,2^32)),32);

%     sM = zeros(1,11);
%     keySet{i} = zeros(1,32);
%     sM = keySet{i-1}(1:11);
%     k = 1;
%     
%     for j=1:32
%         if (j < 22)
%             keySet{i}(j) = keySet{i-1}(j+11);
%         else
%             keySet{i}(j) = sM(k);
%             k = k + 1;
%         end
%     end

%     if( mod(i,4) == mod(0,4) || mod(i,4) == mod(1,4)) 
%         keySet{i} = binaryKey(1:32); 
%     else 
%         keySet{i} = binaryKey(33:64); 
%     end
end

% for i=1:rounds
%    binaryVectorToHex(keySet{i}) 
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        ENCRYPTION        %  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
left = x1(1:32);
right = x1(33:64);
for i = 1:rounds
    
    xorLeftRight = xor(left, right);
    
    %tmp = num2str( binaryVectorToHex(xor(xorLeftRight, keySet{i})));
    
     tmp =  num2str(dec2hex(hex2dec(binaryVectorToHex(xorLeftRight))+ hex2dec(binaryVectorToHex(keySet{i}))));
     
    if(length(tmp) > 8)
        tmp(1) = [];
    end
   
   %tmp
    
    for j=1:length(tmp)
        tmp(j) = s{j}(hex2dec(tmp(j))+1+2);
    end
    tmp = hexToBinaryVector(tmp,32);
    % P - substitution
    temp = tmp;
    for j=1:length(tmp)
        tmp(j) = temp(pt(j));
    end
    
    tmpR = right;
    right = xor(tmpR,tmp);
    
    tmpL = left;
    left = xor(tmpL,tmp);
   
end

encrypted(1:32) = left;
encrypted(33:64) = right;
binaryVectorToHex(encrypted)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        DECRYPTION        %  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%left1 = encrypted(1:32);
%right1 = encrypted(33:64);
left1 = x1(1:32);
right1 = x1(33:64);
for i = 1:rounds
    
    xorLeftRight1 = xor(left1, right1);
    
%    tmp = num2str( binaryVectorToHex(xor(xorLeftRight1, keySet{rounds-i+1})));
    
     tmp =  num2str(dec2hex(hex2dec(binaryVectorToHex(xorLeftRight1))+ hex2dec(binaryVectorToHex(keySet{rounds-i+1}))));
     
    if(length(tmp) > 8)
        tmp(1) = [];
    end
   
    for j=1:length(tmp)
        tmp(j) = s{j}(hex2dec(tmp(j))+1+2);
    end
    tmp = hexToBinaryVector(tmp,32);
    % P - substitution
    temp = tmp;
    for j=1:length(tmp)
        tmp(j) = temp(pt(j));
    end
    
    tmpR = right1;
    right1 = xor(tmpR,tmp);
    
    tmpL = left1;
    left1 = xor(tmpL,tmp);  
   
end
decrypted(1:32) = left1;
decrypted(33:64) = right1;
binaryVectorToHex(decrypted)
